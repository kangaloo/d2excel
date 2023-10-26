package theme

import (
	"image/color"

	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/theme"

	"github.com/kangaloo/d2excel/bundle"
)

type Theme struct{}

var _ fyne.Theme = (*Theme)(nil)

func (*Theme) Font(s fyne.TextStyle) fyne.Resource {
	return bundle.ResourceAvenirNextTtc
}

func (*Theme) Color(n fyne.ThemeColorName, v fyne.ThemeVariant) color.Color {
	return theme.DefaultTheme().Color(n, v)
}

func (*Theme) Icon(n fyne.ThemeIconName) fyne.Resource {
	return theme.DefaultTheme().Icon(n)
}

func (*Theme) Size(n fyne.ThemeSizeName) float32 {
	return theme.DefaultTheme().Size(n)
}
