package main

import (
	"context"
	"fmt"
	"io/ioutil"
	"log"
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

			DownloadObject(s3.Bucket.Name, region, key, gzFilePath)

			in, err := ioutil.ReadFile(gzFilePath)
			if err != nil {
				log.Fatal(err)
			}

			csvFilePath := strings.ReplaceAll(gzFilePath, ".gz", "")
			out, err := os.Create(csvFilePath)
			if err != nil {
				log.Fatal(err)
			}

			Gunzip(out, in)
		}
	}

	files, _ := ioutil.ReadDir(os.TempDir())

	fmt.Println("Content of /tmp")
	for _, file := range files {
		fmt.Println(file.Name())
	}

	return "", nil
}

func main() {
	lambda.Start(HandleRequest)
}
