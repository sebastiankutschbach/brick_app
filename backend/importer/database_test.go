package main

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

var databaseName = "test"
var collectionName = "test"

var header = []string{"column0", "column1", "column2"}
var data = [][]string{
	{"data_0_0", "data_0_1", "data_0_2"},
	{"data_1_0", "data_1_1", "data_1_2"},
	{"data_2_0", "data_2_1", "data_2_2"},
}

func TestImportData(t *testing.T) {
	ctx, client, cancel, err := setupMongo()
	if err != nil {
		t.Fatal(err)
	}
	defer cancel()
	defer dropDatabase(ctx, *client)

	ImportData("test", "test", header, data)

	dbNames, err := client.ListDatabaseNames(ctx, bson.M{"name": databaseName})
	if err != nil {
		t.Fatal(err)
	}
	assert.NotEmpty(t, dbNames)

	database := client.Database(databaseName)
	collectionNames, err := database.ListCollectionNames(ctx, bson.M{"name": collectionName})
	if err != nil {
		t.Fatal(err)
	}
	assert.NotEmpty(t, collectionNames)

	collection := database.Collection(collectionName)
	cursor, err := collection.Find(ctx, bson.M{})
	if err != nil {
		t.Fatal(err)
	}
	assert.Equal(t, cursor.RemainingBatchLength(), 3)
}

func setupMongo() (ctx context.Context, client *mongo.Client, cancel context.CancelFunc, err error) {
	ctx, cancel = context.WithTimeout(context.Background(), 20*time.Second)
	client, err = mongo.Connect(ctx, options.Client().ApplyURI("mongodb://localhost:27017"))
	if err != nil {
		panic(err)
	}
	return
}

func dropDatabase(ctx context.Context, client mongo.Client) {
	err := client.Database(databaseName).Drop(ctx)
	if err != nil {
		panic(err)
	}
}
