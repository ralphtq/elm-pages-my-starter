module Lib.UIparts exposing (..)

-- import Checkboxes exposing (Msg)

import Basics.Extra as BasicsX exposing (flip)
import Color exposing (Color)
import Effect exposing (Effect)
import Element as E exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (..)
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html, b)
import Html.Attributes as Attr
import Html.Parser
import Html.Parser.Util
import Lib.Core exposing (..)
import Markdown.Block as Markdown
import Markdown.Parser as Markdown
import Markdown.Renderer as Markdown
import Maybe.Extra as MaybeX exposing (withDefaultLazy)
import Shared exposing (..)


banner : Job -> Element msg
banner job =
    row
        [ spacing 10
        , height <| px 60
        , padding 32
        ]
        [ if job.jobName /= "" then
            image
                [ width <| px 100, alignLeft ]
                { src = "./images/graphs2go_logo.png"
                , description = "Graphs2Go Logo"
                }

          else
            emptyContent
        , if job.jobIcon /= "" then
            image
                [ width <| px 140 ]
                { src = job.jobIcon
                , description = "Job Logo"
                }

          else
            emptyContent
        , row
            [ centerX
            , height <| px 60
            , padding 32
            , spacing 10
            ]
            [ paragraph [ centerX, Font.bold, Font.size 32, padding 10 ]
                [ text <| job.jobName ]
            , if job.jobAttributionIcon /= "" then
                image
                    [ width <| px 140 ]
                    { src = job.jobAttributionIcon
                    , description = "Attribution Logo"
                    }

              else
                emptyContent
            ]
        ]


titleAttributes : List (Attribute msg)
titleAttributes =
    [ Font.bold
    , Font.size 22
    , Font.color color.darkBlue
    , paddingXY 0 10
    , spacingXY 0 10
    , width <| minimum 800 (fillPortion 3)
    ]


renderBody : Int -> List (ChannelItem msg) -> List (Element msg) -> Element msg
renderBody channelWidth channelItems mastItems =
    row
        [ height <| minimum 1000 (fillPortion 3)
        , width <| minimum 200 (fillPortion 2)
        ]
        [ if channelWidth /= 0 then
            channelPanel channelWidth channelItems 0

          else
            emptyContent
        , column
            [ height fill
            , width <| minimum 0 (fillPortion 11)
            ]
            mastItems
        ]


mastHeader : String -> List (Button msg) -> Element msg
mastHeader preambleText buttons =
    row
        [ width <| minimum 0 (fillPortion 1)
        , paddingXY 0 20
        , Border.widthEach { bottom = 2, top = 0, left = 0, right = 0 }
        , Border.color color.lightGray
        ]
        [ paragraph
            [ Font.color color.darkBlue
            , paddingXY 20 0
            , Font.size 32
            ]
          <|
            [ markdownToElmUI <|
                preambleText
            ]
        , row [ spacing 10, alignRight ]
            (buttons
                |> List.map (\b -> makeButton b)
            )
        ]


canvasAttributes : List (Attribute msg)
canvasAttributes =
    [ width <| minimum 0 fill
    , height <| minimum 0 fill
    , padding 0
    , spacingXY 0 0
    , scrollbarY
    ]


spacer : Int -> Element msg
spacer padAmount =
    el [ padding padAmount ] <| text ""


emptyContent : Element msg
emptyContent =
    spacer 0


canvasContent : Maybe (List (Attribute msg)) -> List (Element msg) -> Element msg
canvasContent attributes elements =
    -- Workaround, if needed: set min height of 0 to override column sizing to content
    attributes
        |> MaybeX.withDefaultLazy (\() -> canvasAttributes)
        |> flip column elements


htmlMarkup : Maybe (List (Attribute msg)) -> String -> Element msg
htmlMarkup attributes htmlString =
    attributes
        |> MaybeX.withDefaultLazy (\() -> canvasAttributes)
        |> flip paragraph [ html (renderTextHtml htmlString) ]


renderTextHtml : String -> Html msg
renderTextHtml t =
    case Html.Parser.run t of
        Ok nodes ->
            Html.div []
                (Html.Parser.Util.toVirtualDom nodes)

        Err err ->
            Html.div []
                [ Html.span
                    [ Attr.class "italic" ]
                    [ Html.text "Problem with HTML string: " ]
                , Html.span [] [ Html.text t ]
                , Html.p [ Attr.class "italic" ] [ Html.text <| Debug.toString err ]
                ]


channelPanel : Int -> List (ChannelItem msg) -> Int -> Element msg
channelPanel channelWidth channels activeChannel =
    column
        (channelsContainerAttributes channelWidth)
    <|
        List.map channelElement channels


channelsContainerAttributes : Int -> List (Attribute msg)
channelsContainerAttributes channelWidth =
    [ height fill
    , width <| fillPortion channelWidth
    , paddingXY 0 10
    , scrollbarY
    , Background.color color.lightPurple
    , Font.color color.white
    , Border.width 2
    , Border.rounded 8
    , Border.color color.lightPurple
    ]


channeItemSlotAttributes : List (Attribute msg)
channeItemSlotAttributes =
    [ width fill
    , alignLeft
    , paddingXY 10 5
    ]


channelElement : ChannelItem msg -> Element msg
channelElement channel =
    el channeItemSlotAttributes <|
        case channel of
            ChannelButton button ->
                makeButton button

            ChannelDivider ->
                hr

            ChannelText str ->
                text str

            ChannelButtonWithSubList button subList ->
                column []
                    (makeButton button
                        :: (subList |> List.map (\slb -> channelElement slb))
                    )


channelButtonAttributes : List (Attribute msg)
channelButtonAttributes =
    [ padding 5
    , alignLeft
    , Border.width 2
    , Border.rounded 6
    , Border.color color.blue
    , Background.color color.darkBlue
    , mouseOver
        [ Background.color color.lightBlue, Font.color color.white ]
    ]


channelSubListButtonAttributes : List (Attribute msg)
channelSubListButtonAttributes =
    [ padding 5
    , alignLeft
    , Font.color color.royalBlue
    , Font.size 16
    , mouseOver
        [ Background.color color.lightBlue, Font.color color.white ]
    ]


type ChannelItem msg
    = ChannelButton (Button msg)
    | ChannelDivider
    | ChannelText String
    | ChannelButtonWithSubList (Button msg) (List (ChannelItem msg))


type alias Button msg =
    { label : String
    , attributes : List (Attribute msg)
    , onClick : msg
    }


type alias Rectangle msg =
    Element msg


makeButton : Button msg -> Element msg
makeButton button =
    Input.button
        button.attributes
        { onPress = Just button.onClick
        , label = E.paragraph [] [ text <| button.label ]
        }


hr : Element msg
hr =
    el [ padding 10, width fill ] <|
        row
            [ spacingXY 0 0
            , width fill
            , Border.width 1
            , Border.rounded 1
            , Border.color color.darkBlue
            ]
            [ el [ Background.color color.white ] none
            ]


footer : Element msg
footer =
    el [ alignBottom, padding 20, width fill ] <|
        row
            [ spacingXY 2 0
            , width fill
            , Border.width 2
            , Border.rounded 6
            , Border.color color.blue
            ]
            [ el
                [ padding 5
                , Border.widthEach { right = 2, left = 0, top = 0, bottom = 0 }
                , Border.color color.blue
                , Font.bold
                , mouseOver [ Background.color color.lightBlue ]
                ]
              <|
                text " + "
            , el [ Background.color color.white ] none
            ]


mastButtonAttributes : List (Attribute msg)
mastButtonAttributes =
    [ padding 5
    , Border.width 2
    , Border.rounded 6
    , Border.color color.blue
    , Background.color color.lightBlue
    , mouseOver
        [ Background.color color.white, Font.color color.blue ]
    ]


markdownToHTML : MarkdownString -> Html msg
markdownToHTML mdText =
    mdText
        |> Markdown.parse
        |> Result.mapError (List.map Markdown.deadEndToString >> String.join "\n")
        |> Result.andThen (Markdown.render Markdown.defaultHtmlRenderer)
        |> Result.map (Html.main_ [])
        |> Result.withDefault (Html.text "Error occurred. This shouldn't happen.")


htmlToElement : List (Attribute msg) -> List (Html msg) -> Element msg
htmlToElement atts htmlPieces =
    htmlPieces
        |> List.map html
        |> column atts


markdownToElmUI : MarkdownString -> Element msg
markdownToElmUI mdText =
    mdText
        |> Markdown.parse
        |> Result.mapError (List.map Markdown.deadEndToString >> String.join "\n")
        |> Result.andThen (Markdown.render Markdown.defaultHtmlRenderer)
        |> Result.map (htmlToElement [])
        |> Result.withDefault (text "Error occurred. This shouldn't happen.")
