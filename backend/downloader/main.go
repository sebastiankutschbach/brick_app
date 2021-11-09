package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/lambda"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3/s3manager"
)

var urls = [12]string{
	"https://cdn.rebrickable.com/media/downloads/themes.csv.gz",
	"https://cdn.rebrickable.com/media/downloads/colors.csv.gz",
	"https://cdn.rebrickable.com/media/downloads/part_categories.csv.gz",
	"https://cdn.rebrickable.com/media/downloads/parts.csv.gz",
	"https://cdn.rebrickable.com/media/downloads/part_relationships.csv.gz",
	"https://cdn.rebrickable.com/media/downloads/elements.csv.gz",
	"https://cdn.rebrickable.com/media/downloads/sets.csv.gz",
	"https://cdn.rebrickable.com/media/downloads/minifigs.csv.gz",
	"https://cdn.rebrickable.com/media/downloads/inventories.csv.gz",
	"https://cdn.rebrickable.com/media/downloads/inventory_parts.csv.gz",
	"https://cdn.rebrickable.com/media/downloads/inventory_sets.csv.gz",
	"https://cdn.rebrickable.com/media/downloads/inventory_minifigs.csv.gz"}

func HandleRequest() (string, error) {
	bucketName, success := os.LookupEnv("BUCKET")
	if !success {
		errMsg := "Environment variable BUCKET not set. Exiting."
		fmt.Println(errMsg)
		panic(errMsg)
	}
	for _, fileUrl := range urls {
		elems := strings.Split(fileUrl, "/")
		fileName := elems[len(elems)-1]
		path := "/tmp/" + fileName
		err := DownloadFile(path, fileUrl)
		if err != nil {
			panic(err)
		}
		fmt.Println("Downloaded: " + fileUrl)

		uploadToS3(bucketName, path, fileName)
	}
	return "", nil
}

func main() {
	lambda.Start(HandleRequest)
}

func DownloadFile(filepath string, url string) error {

	// Get the data
	resp, err := http.Get(url)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	// Create the file
	out, err := os.Create(filepath)
	if err != nil {
		return err
	}
	defer out.Close()

	// Write the body to file
	_, err = io.Copy(out, resp.Body)

	return err
}

func uploadToS3(bucketName string, filePath string, key string) {
	awsConfig := &aws.Config{
		Region: aws.String("eu-central-1"),
	}

	// The session the S3 Uploader will use
	sess := session.Must(session.NewSession(awsConfig))

	// Create an uploader with the session and custom options
	uploader := s3manager.NewUploader(sess, func(u *s3manager.Uploader) {
		u.PartSize = 5 * 1024 * 1024 // The minimum/default allowed part size is 5MB
		u.Concurrency = 2            // default is 5
	})

	//open the file
	f, err := os.Open(filePath)
	if err != nil {
		return
	}
	defer f.Close()

	// Upload the file to S3.
	result, err := uploader.Upload(&s3manager.UploadInput{
		Bucket: aws.String(bucketName),
		Key:    aws.String(key),
		Body:   f,
	})

	//in case it fails to upload
	if err != nil {
		fmt.Printf("failed to upload file, %v", err)
		return
	}
	fmt.Printf("file uploaded to, %s\n", result.Location)
}
