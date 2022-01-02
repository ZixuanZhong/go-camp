package pkg

import (
	"sync"
	"time"
)

type Bucket struct {
	Value int
}

type SlidingWindow struct {
	Buckets map[int64]*Bucket
	Mutex   *sync.RWMutex
}

func NewSlidingWindow() *SlidingWindow {
	return &SlidingWindow{
		Buckets: make(map[int64]*Bucket),
		Mutex:   &sync.RWMutex{},
	}
}

func (sw *SlidingWindow) getCurrentBucket(ts int64) *Bucket {
	var bucket *Bucket
	var ok bool
	if bucket, ok = sw.Buckets[ts]; !ok {
		bucket = &Bucket{}
		sw.Buckets[ts] = bucket
	}
	return bucket
}

func (sw *SlidingWindow) removeOldBuckets(ts int64) {
	earliest := ts - 10
	for timestamp := range sw.Buckets {
		if timestamp <= earliest {
			delete(sw.Buckets, timestamp)
		}
	}
}

func (sw *SlidingWindow) Increment(i int) {
	if i == 0 {
		return
	}

	now := time.Now().Unix()

	sw.Mutex.Lock()
	defer sw.Mutex.Unlock()

	b := sw.getCurrentBucket(now)
	b.Value += i

	sw.removeOldBuckets(now)
}

func (sw *SlidingWindow) Sum() int {

	sum := int(0)
	now := time.Now().Unix()

	sw.Mutex.RLock()
	defer sw.Mutex.RUnlock()

	for timestamp, bucket := range sw.Buckets {
		if timestamp >= now-10 {
			sum += bucket.Value
		}
	}

	return sum
}
