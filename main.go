package main

import (
	"fmt"
	"sync"
	"sync/atomic"

	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/widget"

	"github.com/kangaloo/d2excel/theme"
)

func main() {
	count := 0
	application := app.New()
	application.Settings().SetTheme(&theme.Theme{})

	window := application.NewWindow("Hello")
	window.Resize(fyne.Size{Width: 500, Height: 500})

	hello := widget.NewLabel("Hello Fyne!")
	window.SetContent(container.NewVBox(
		hello,
		widget.NewButton("加1", func() {
			count += 1
			text := fmt.Sprintf("hello %d", count)
			hello.SetText(text)
		}),
	))

	// window.ShowAndRun()
	window.Show()
	application.Run()
}

func AtomicTest() {
	var a int32 = 0
	var wg sync.WaitGroup
	for i := 0; i < 500; i++ {
		wg.Add(1)
		go func() {
			atomic.AddInt32(&a, 1)
			wg.Done()
		}()
	}
	wg.Wait()
}
