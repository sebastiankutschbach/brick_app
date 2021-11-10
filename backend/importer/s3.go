package main

import (
	"fmt"
	"os"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/aws/aws-sdk-go/service/s3/s3manager"
)

func DownloadObject(bucketName string, region string, key string, file string) {
	awsConfig := &aws.Config{
		Region: aws.String(region),
	}

	// The session the S3 Uploader will use
	sess := session.Must(session.NewSession(awsConfig))

	// Create an uploader with the session and custom options
	downloader := s3manager.NewDownloader(sess, func(d *s3manager.Downloader) {
		d.PartSize = 5 * 1024 * 1024 // The minimum/default allowed part size is 5MB
		d.Concurrency = 2            // default is 5
	})

	//open the file
	f, err := os.Create(file)
	if err != nil {
		return
	}
	defer f.Close()

	// Upload the file to S3.
	_, err = downloader.Download(f, &s3.GetObjectInput{
		Bucket: aws.String(bucketName),
		Key:    aws.String(key),
	})

	//in case it fails to upload
	if err != nil {
		fmt.Printf("failed to download file, %v", err)
		return
	}
	fmt.Printf("file downloaded successfully from: %s\n", file)
}
