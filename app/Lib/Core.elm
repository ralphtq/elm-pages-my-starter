module Lib.Core exposing (..)

-- import Element.Background as Background
-- import Element.Border as Border

import Element exposing (..)
import Element.Events exposing (..)



-- import Element.Font as Font
-- import Element.Input as Input


type alias MarkdownString =
    String


type alias Message =
    { author : String, time : String, text : String }


color =
    { auburn = rgb255 160 0 0
    , black = rgb255 0 0 0
    , blue = rgb255 0x72 0x9F 0xCF
    , blueGray = rgb255 163 211 231
    , darkBlue = rgb255 0x34 0x78 0xC6
    , darkCharcoal = rgb255 0x2E 0x34 0x36
    , electricPurple = rgb255 64 0 149
    , ghostWhite = rgb255 211 224 233
    , lightBlue = rgb255 0xC5 0xE8 0xF7
    , lightGray = rgb255 0xE0 0xE0 0xE0
    , lightPurple = rgb255 0xF2 0xF2 0xFE
    , mildOrange = rgb255 0xDE 0x8F 0x57
    , royalBlue = rgb255 1 49 131
    , silver = rgb255 192 191 186
    , white = rgb255 0xFF 0xFF 0xFF
    }
