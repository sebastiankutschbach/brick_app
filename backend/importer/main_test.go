package main

import (
	"context"
	"testing"

	"github.com/aws/aws-lambda-go/events"
)

func TestHandleRequest(t *testing.T) {
	event := new(events.S3Event)
	event.Records = []events.S3EventRecord{*new(events.S3EventRecord)}
	context := new(context.Context)
	HandleRequest(*context, *event)
}
