package main

import (
	"context"
	"fmt"
	"io/ioutil"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func HandleRequest(ctx context.Context, s3Event events.S3Event) (string, error) {
	region, success := os.LookupEnv("REGION")
	if !success {
		errMsg := "Environment variable REGION not set. Exiting."
		fmt.Println(errMsg)
		panic(errMsg)
	}

	for _, record := range s3Event.Records {
		s3 := record.S3
		key := s3.Object.Key
		fmt.Printf("[%s - %s] Bucket = %s, Key = %s \n", record.EventSource, record.EventTime, s3.Bucket.Name, key)
		if strings.HasSuffix(key, ".csv.gz") {
			gzFilePath := "/tmp/" + key
			fmt.Printf("FilePath : %s\n", gzFilePath)

			err := DownloadObject(s3.Bucket.Name, region, key, gzFilePath)
			if err != nil {
				panic(err)
			}

			in, err := ioutil.ReadFile(gzFilePath)
			if err != nil {
				panic(err)
			}

			csvFilePath := strings.ReplaceAll(gzFilePath, ".gz", "")
			out, err := os.Create(csvFilePath)
			if err != nil {
				panic(err)
			}
			defer out.Close()

			fmt.Printf("Unzipping %s\n", gzFilePath)
			err = Gunzip(out, in)
			if err != nil {
				panic(err)
			}

			out.Seek(0, 0)
			fmt.Printf("Parsing %s\n", csvFilePath)
			header, data, err := ParseCsv(out)
			if err != nil {
				panic(err)
			}

			databaseName := "bricks"
			collectionName := strings.ReplaceAll(key, ".csv.gz", "")
			err = ImportData(databaseName, collectionName, header, data)
			if err != nil {
				panic(err)
			}
		}
	}

	return "", nil
}

func main() {
	lambda.Start(HandleRequest)
}
