package main

import (
	"context"
	"strconv"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func ImportData(databaseName string, collectionName string, header []string, data [][]string) (err error) {
	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()
	client, err := mongo.Connect(ctx, options.Client().ApplyURI("mongodb://localhost:27017"))
	if err != nil {
		return err
	}
	collection := client.Database(databaseName).Collection(collectionName)
	collection.InsertMany(ctx, createDocs(header, data))

	return nil
}

func createDocs(header []string, data [][]string) (docs []interface{}) {
	for _, rowData := range data {
		var elems = []bson.E{}
		for columnNumber, columnName := range header {
			intValue, err := strconv.Atoi(rowData[columnNumber])
			elem := bson.E{}
			if err != nil {
				elem = bson.E{Key: columnName, Value: rowData[columnNumber]}
			} else {
				elem = bson.E{Key: columnName, Value: intValue}
			}
			elems = append(elems, elem)
		}
		docs = append(docs, elems)
	}

	return docs
}
