package main

import (
	"database/sql"
	"fmt"
	"log"

	"github.com/pkg/errors"
)

type row string

func dbQuery(output []row) error {
	return sql.ErrNoRows
}

func getResults() ([]row, error) {
	var result []row
	err := dbQuery(result)
	if err != nil {
		if err == sql.ErrNoRows {
			return make([]row, 0), nil
		}
		return nil, errors.Wrap(err, "query failed")
	}
	return result, nil
}

func main() {
	res, err := getResults()
	if err != nil {
		log.Printf("get results failed, err: %v", err)
	}
	fmt.Printf("results: %v\n", res)
}
