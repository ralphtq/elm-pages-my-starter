module Route.Index exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Pages.Url
import PagesMsg exposing (PagesMsg)
import UrlPath
import Route
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import View exposing (View)
import Element as E exposing (Element)
import Markdown.Block as Markdown
import Markdown.Parser as Markdown
import Markdown.Renderer as Markdown

type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}

type alias MarkdownString =
    String

type alias Data =
    { message : String
    }


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


data : BackendTask FatalError Data
data =
    BackendTask.succeed Data
        |> BackendTask.andMap
            (BackendTask.succeed "Hello!")


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = [ "images", "icon-png.png" ] |> UrlPath.join |> Pages.Url.fromPath
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Welcome to elm-pages!"
        , locale = Nothing
        , title = "elm-pages is running"
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app shared =
    { title = "elm-pages is running"
    , body =
        [ elmPagesRunning
        , Html.p []
            [ Html.text <| "The message is: " ++ app.data.message
            ]
        , E.layout [] qudtOpener
        , markdownToHTML domainOverview
        , markdownToHTML qudtBrief
        , Route.Blog__Slug_ { slug = "hello" }
            |> Route.link [] [ Html.text "My blog post" ]
        ]
    }

markdownToHTML : MarkdownString -> Html msg
markdownToHTML mdText =
    mdText
        |> Markdown.parse
        |> Result.mapError (List.map Markdown.deadEndToString >> String.join "\n")
        |> Result.andThen (Markdown.render Markdown.defaultHtmlRenderer)
        |> Result.map (Html.main_ [])
        |> Result.withDefault (Html.text "Error occurred. This shouldn't happen.")

qudtOpenerAsHTML : Html.Html msg
qudtOpenerAsHTML = E.layout [] qudtOpener

elmPagesRunning : Html.Html msg
elmPagesRunning = Html.h1 [] [ Html.text "elm-pages up and running!" ]

qudtOpener : Element msg
qudtOpener = 
    E.el [] <| E.text "Test QUDT Element"

domainOverview : MarkdownString
domainOverview =
    """
**QUDT.org** is a 501(c)(3) public charity nonprofit organization founded to provide semantic specifications for units of measure, quantity kind, dimensions and data types. 
QUDT is an advocate for the development and implementation of standards to quantify data expressed in RDF and JSON. 
Our mission is to improve interoperability of data and the specification of information structures through industry standards for Units of Measure, Quantity Kinds, Dimensions and Data Types.

QUDT.org operates thanks to volunteers, but we do have infrastructural costs of course. If you value the QUDT ontologies as a resource available to all, please consider a [donation]("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=HPQG536BSRNB4&source=url") of any amount (tax deductible in the USA). That will allow us to keep going and growing.
"""

qudtBrief : MarkdownString
qudtBrief =
    """
QUDT ontologies are organized as collections of different types of graphs, as listed in the QUDT catalog. 
Vocabulary graphs hold different domains of quantities and units, which import the appropriate QUDT schemas. 
The core schema of QUDT imports the 
[VAEM](http://www.linkedmodel.org/doc/vaem/1.2/index.html), 
[DTYPE](https://linkedmodel.org/doc/dtype/1.0/) and [SKOS](https://www.w3.org/2009/08/skos-reference/skos.html) ontologies.

The core design pattern of the QUDT ontology is shown here:

![QUDT Design Pattern](https://github.com/qudt/qudt-public-repo/wiki/Quantity_Triad_Pattern.png "QUDT Schema Model Overview")
 """
