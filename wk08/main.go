package main

import (
	"context"
	"fmt"

	"github.com/go-redis/redis/v8"
	"github.com/hhxsv5/go-redis-memory-analysis"
)

var client redis.UniversalClient
var ctx context.Context

const (
	ip   string = "127.0.0.1"
	port uint16 = 6379
)

func init() {
	client = redis.NewClient(&redis.Options{
		Addr:         fmt.Sprintf("%v:%v", ip, port),
		Password:     "",
		DB:           0,
		PoolSize:     128,
		MinIdleConns: 100,
		MaxRetries:   5,
	})

	ctx = context.Background()
}

func main() {
	// write(10000, "50bytes_10k", generateValue(50))
	write(100000, "50bytes_100k", generateValue(50))
	// write(500000, "50bytes_500k", generateValue(50))

	// write(10000, "500bytes_10k", generateValue(500))
	write(100000, "500bytes_100k", generateValue(500))
	// write(500000, "500bytes_500k", generateValue(500))

	// write(10000, "5000bytes_10k", generateValue(5000))
	write(100000, "5000bytes_100k", generateValue(5000))
	// write(500000, "5000bytes_500k", generateValue(5000))

	runAnalysis()
}

func write(num int, key, value string) {
	fmt.Printf("write %s\n", key)
	for i := 0; i < num; i++ {
		k := fmt.Sprintf("%s:%v", key, i)
		cmd := client.Set(ctx, k, value, -1)
		err := cmd.Err()
		if err != nil {
			fmt.Println(cmd.String())
		}
	}
}

func runAnalysis() {
	analysis, err := gorma.NewAnalysisConnection(ip, port, "")
	if err != nil {
		fmt.Println("something wrong:", err)
		return
	}
	defer analysis.Close()

	analysis.Start([]string{":"})

	err = analysis.SaveReports("./reports")
	if err == nil {
		fmt.Println("done")
	} else {
		fmt.Println("error:", err)
	}
}

func generateValue(size int) string {
	arr := make([]byte, size)
	for i := 0; i < size; i++ {
		arr[i] = 'a'
	}
	return string(arr)
}
