package main

import (
	"context"
	"log"
	"os"
	"testing"

	"github.com/aws/aws-lambda-go/events"
	"github.com/stretchr/testify/assert"

	"github.com/aws/aws-sdk-go/aws/credentials"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)

var svc = s3.New(session.Must(session.NewSession(
	&aws.Config{
		Credentials:      credentials.NewStaticCredentials("aaa", "bbbbbbbb", ""),
		Region:           aws.String("eu-central-1"),
		Endpoint:         aws.String("http://localhost:9000"),
		S3ForcePathStyle: aws.Bool(true),
	})))

var bucketNameString = "bucket"
var bucketName = aws.String(bucketNameString)

var objectKeyString = "myKey.csv.gz"
var objectKey = aws.String(objectKeyString)

func setup(t *testing.T, svc s3.S3) {
	_, err := svc.CreateBucket(&s3.CreateBucketInput{Bucket: bucketName})
	if err != nil {
		t.Fatal(err)
	}
	f, err := os.Open("testdata/themes.csv.gz")
	if err != nil {
		log.Fatal(err)
	}
	_, err = svc.PutObject(&s3.PutObjectInput{Bucket: bucketName, Body: f, Key: objectKey})
	if err != nil {
		t.Fatal(err)
	}
}

func shutdown(t *testing.T, svc s3.S3) {
	_, err := svc.DeleteObject(&s3.DeleteObjectInput{Bucket: bucketName, Key: objectKey})
	if err != nil {
		t.Fatal(err)
	}
	_, err = svc.DeleteBucket(&s3.DeleteBucketInput{Bucket: bucketName})
	if err != nil {
		t.Fatal(err)
	}
}

func TestHandleRequest(t *testing.T) {
	setup(t, *svc)
	defer shutdown(t, *svc)

	os.Setenv("REGION", "eu-central-1")
	os.Setenv("TEST", "")
	record := events.S3EventRecord{
		S3: events.S3Entity{
			Bucket: events.S3Bucket{
				Name: bucketNameString,
			},
			Object: events.S3Object{
				Key: objectKeyString,
			},
		},
	}
	event := events.S3Event{
		Records: []events.S3EventRecord{record},
	}
	context := new(context.Context)
	HandleRequest(*context, event)

	assert.True(t, true)
}
