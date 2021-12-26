package main

import (
	"context"
	"flag"
	"fmt"
	"os"
	"os/signal"

	"github.com/pkg/errors"
	"golang.org/x/sync/errgroup"

	"hw03/config"
	"hw03/server"
)

func main() {

	environment := flag.String("e", "development", "")
	flag.Parse()
	config.Init(*environment)

	g, ctx := errgroup.WithContext(context.Background())

	g.Go(func() error {
		go func() {
			server.Init()
			<-ctx.Done()
			server.Shutdown()
		}()
		return nil
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
