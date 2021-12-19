package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"

	"github.com/pkg/errors"
	"golang.org/x/sync/errgroup"
)

type httpServer interface {
	area() float64
	perim() float64
}

func main() {
	g, ctx := errgroup.WithContext(context.Background())

	server := &http.Server{
		Addr: ":8080",
	}

	g.Go(func() error {
		go func() {
			<-ctx.Done()
			server.Shutdown(context.Background())
		}()
		return server.ListenAndServe()
	})

	g.Go(func() error {
		sigChan := make(chan os.Signal, 1)
		signal.Notify(sigChan)
		for {
			select {
			case <-ctx.Done():
				return ctx.Err()
			case sig := <-sigChan:
				return errors.Errorf("signal=%v", sig)
			}
		}
	})

	err := g.Wait()
	fmt.Println(err)
}
