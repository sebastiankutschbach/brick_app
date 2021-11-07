package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/lambda"
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

type MyEvent struct {
	Name string `json:"name"`
}

func HandleRequest() (string, error) {

	for _, fileUrl := range urls {
		elems := strings.Split(fileUrl, "/")
		path := "/tmp/" + elems[len(elems)-1]
		err := DownloadFile(path, fileUrl)
		if err != nil {
			panic(err)
		}
		fmt.Println("Downloaded: " + fileUrl)
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
