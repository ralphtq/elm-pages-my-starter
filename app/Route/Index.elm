module Route.Index exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import Color exposing (Color)
import Element as E exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (..)
import Element.Font as Font
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Lib.Core exposing (..)
import Lib.UIparts exposing (..)
import Markdown.Block as Markdown
import Markdown.Parser as Markdown
import Markdown.Renderer as Markdown
import Pages.Url
import PagesMsg exposing (PagesMsg)
import Route
import RouteBuilder exposing (App, StatelessRoute)
import Shared exposing (..)
import UrlPath
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()



-- type Msg
--     = NoOp
--     |  LoadExternalUrl String


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
        , title = "LMDOC"
        }
        |> Seo.website


defaultJob : Job
defaultJob =
    { jobName = ""
    , jobAcronym = "QUDT"
    , jobIcon = "../images/qudt_logo-300x110.png"
    , jobAttributionIcon = ""
    }



-- homeButton : Button msg


homeButton =
    { label = "Home"
    , attributes = mastButtonAttributes
    , onClick = NoOp -- GoHome SHACLbuiltState
    }


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg ())
view app shared =
    let
        channelWidth =
            2
    in
    { title = "elm-pages is running"
    , body =
        [ Html.div []
            [ layout [ padding 10, height fill ] <|
                column [ width fill, height fill ]
                    [ banner defaultJob
                    , row
                        [ height <| minimum 1000 (fillPortion 3)
                        , width <| minimum 200 (fillPortion 2)
                        ]
                        [ if channelWidth /= 0 then
                            channelPanel channelWidth [] 0

                          else
                            emptyContent
                        , column
                            [ height fill
                            , width <| minimum 0 (fillPortion 11)
                            ]
                            [ mastHeader "**QUDT**: **Q**uantity Kinds, **U**nits, **D**imensions, and **T**ypes"
                                [--     { label = "Home"
                                 --   , attributes = mastButtonAttributes
                                 --   , onClick = NoOp -- GoHome SHACLbuiltState
                                 --   }
                                ]

                            -- , { label = "Overview"
                            --   , attributes = mastButtonAttributes
                            --   , onClick = NoOp -- NoOp -- LoadExternalUrl "http://www.qudt.org/pages/QUDToverviewPage.html"
                            --   }
                            -- , { label = "Catalog"
                            --   , attributes = mastButtonAttributes
                            --   , onClick = NoOp -- LoadExternalUrl "http://www.qudt.org/2.1/catalog/qudt-catalog.html"
                            --   }
                            -- , { label = "About"
                            --   , attributes = mastButtonAttributes
                            --   , onClick = NoOp -- LoadExternalUrl "https://www.qudt.org/pages/AboutQUDTpage.html#"
                            --   }
                            -- , { label = "Contact"
                            --   , attributes = mastButtonAttributes
                            --   , onClick = NoOp -- LoadExternalUrl "http://www.qudt.org/pages/QUDTcontactsPage.html"
                            --   }
                            -- , { label = "Join"
                            --   , attributes = mastButtonAttributes
                            --   , onClick = NoOp -- LoadExternalUrl "http://www.qudt.org/pages/JoinQUDTpage.html"
                            --   }
                            -- , { label = "Donate"
                            --   , attributes = mastButtonAttributes
                            --   , onClick = NoOp -- LoadExternalUrl "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=HPQG536BSRNB4&source=url"
                            --   }
                            ]
                        ]
                    , column
                        [ paddingXY 20 20
                        , width fill
                        , spacingXY 0 5
                        ]
                        [ column
                            [ paddingXY 10 10
                            , Background.color color.lightBlue
                            , Border.solid
                            , Border.width 2
                            , Border.color color.darkBlue
                            , Border.rounded 16
                            ]
                            [ paragraph [] [ markdownToElmUI domainOverview ]]
                            , column [ paddingXY 0 20, spacingXY 0 20 ]
                                (contentBlocks
                                    |> List.map (\( h, c ) -> renderContentBlock h c)
                                )
                            ]

                        --  , canvasContent Nothing (domainContentsPaneContent shared)
                        --  (domainContentsPane shared <| "**QUDT**: **Q**uantity Kinds, **U**nits, **D**imensions, and **T**ypes")
                        ]
                    -- , domainContentsBody shared
                    ]
            ]
    }

    -- , Route.Blog__Slug_ { slug = "hello" }
    --     |> Route.link [] [ Html.text "My blog post" ]
    -- ]
    -- [ elmPagesRunning
    -- , Html.p []
    --     [ Html.text <| "The message is: " ++ app.data.message
    --     ]
    -- , E.layout [] qudtOpener
    -- , markdownToHTML domainOverview
    -- -- , markdownToHTML qudtBrief
    -- , Route.Blog__Slug_ { slug = "hello" }
    --     |> Route.link [] [ Html.text "My blog post" ]
    -- ]
    -- }


markdownToHTML : MarkdownString -> Html msg
markdownToHTML mdText =
    mdText
        |> Markdown.parse
        |> Result.mapError (List.map Markdown.deadEndToString >> String.join "\n")
        |> Result.andThen (Markdown.render Markdown.defaultHtmlRenderer)
        |> Result.map (Html.main_ [])
        |> Result.withDefault (Html.text "Error occurred. This shouldn't happen.")


qudtOpenerAsHTML : Html.Html msg
qudtOpenerAsHTML =
    E.layout [] qudtOpener


elmPagesRunning : Html.Html msg
elmPagesRunning =
    Html.h1 [] [ Html.text "elm-pages up and running!" ]


qudtOpener : Element msg
qudtOpener =
    E.el [] <| E.text "Test QUDT Element"


domainContentsBody : Shared.Model -> Element SharedMsg
domainContentsBody sharedModel =
    renderBody 2
        [ ChannelButtonWithSubList
            { label = "QUDT Resources", attributes = channelButtonAttributes, onClick = NoOp }
            [ ChannelButton
                { label = "QUDT Catalog Release 2.1"
                , attributes = channelSubListButtonAttributes
                , onClick = NoOp -- LoadExternalUrl "http://www.qudt.org/2.1/catalog/qudt-catalog.html"
                }
            ]
        ]
        -- --     , ChannelButton
        -- --         { label = "GitHub Public Repository"
        -- --         , attributes = channelSubListButtonAttributes
        -- --         , onClick = NoOp -- LoadExternalUrl "http://github.com/qudt/qudt-public-repo"
        -- --         }
        -- --     , ChannelButton
        -- --         { label = "Introduction to QUDT slide presentation"
        -- --         , attributes = channelSubListButtonAttributes
        -- --         , onClick = NoOp -- LoadExternalUrl "https://github.com/qudt/qudt-public-repo/blob/master/docs/2020-04-28%20Intro%20to%20QUDT.pdf"
        -- --         }
        -- --     , ChannelButton
        -- --         { label = "Introductory User Guide (QUDT Wiki)"
        -- --         , attributes = channelSubListButtonAttributes
        -- --         , onClick = NoOp -- LoadExternalUrl "https://github.com/qudt/qudt-public-repo/wiki/User-Guide-for-QUDT"
        -- --         }
        -- --     , ChannelButton
        -- --         { label = "Unit Vocabulary Submission Guide (QUDT Wiki)"
        -- --         , attributes = channelSubListButtonAttributes
        -- --         , onClick = NoOp -- LoadExternalUrl "https://github.com/qudt/qudt-public-repo/wiki/Unit-Vocabulary-Submission-Guidelines"
        -- --         }
        -- --     , ChannelButton
        -- --         { label = "QUDT EDG environment"
        -- --         , attributes = channelSubListButtonAttributes
        -- --         , onClick = NoOp -- LoadExternalUrl "http://www.qudt.org/edg/tbl"
        -- --         }
        -- --     , ChannelButton
        -- --         { label = "QUDT SPARQL Endpoint"
        -- --         , attributes = channelSubListButtonAttributes
        -- --         , onClick = NoOp -- LoadExternalUrl "http://www.qudt.org/fuseki"
        -- --         }
        -- --     ]
        -- -- , ChannelButtonWithSubList { label = "Community Resources", attributes = channelButtonAttributes, onClick = NoOp }
        -- --     [ ChannelButton
        -- --         { label = "QUDTLib: Java Unit Conversion Library based on QUDT"
        -- --         , attributes = channelSubListButtonAttributes
        -- --         , onClick = NoOp -- LoadExternalUrl "https://github.com/qudtlib/qudtlib-java"
        -- --         }
        -- --     , ChannelButton
        -- --         { label = "jQUDT (Another Java QUDT Unit Conversion Library)"
        -- --         , attributes = channelSubListButtonAttributes
        -- --         , onClick = NoOp -- LoadExternalUrl "https://github.com/egonw/jqudt"
        -- --         }
        -- --     , ChannelButton
        -- --         { label = "QUDTLib: Javascript Unit Conversion Library based on QUDT"
        -- --         , attributes = channelSubListButtonAttributes
        -- --         , onClick = NoOp -- LoadExternalUrl "https://github.com/qudtlib/qudtlib-js"
        -- --         }
        -- --     , ChannelButton
        -- --         { label = "Loop3d Profile and Vocabulary of Units"
        -- --         , attributes = channelSubListButtonAttributes
        -- --         , onClick = NoOp -- LoadExternalUrl "https://github.com/qudt/qudt-public-repo/tree/master/community/extensions/loop3d"
        -- --         }
        -- --     ]
        -- -- , ChannelButtonWithSubList { label = "Key Resources", attributes = channelButtonAttributes, onClick = NoOp }
        -- --     [ ChannelButton
        -- --         { label = "The NIST Guide for the use of the International System of Units"
        -- --         , attributes = channelSubListButtonAttributes
        -- --         , onClick = NoOp -- LoadExternalUrl "http://physics.nist.gov/Pubs/SP811/"
        -- --         }
        -- --     , ChannelButton
        -- --         { label = "International Vocabulary of Metrology - Basic and General Concepts and Associated Terms"
        -- --         , attributes = channelSubListButtonAttributes
        -- --         , onClick = NoOp -- LoadExternalUrl "http://www.bipm.org/utils/common/documents/jcgm/JCGM_200_2008.pdf"
        -- --         }
        -- --     , ChannelButton
        -- --         { label = "SI Brochure, 9th Edition"
        -- --         , attributes = channelSubListButtonAttributes
        -- --         , onClick = NoOp -- LoadExternalUrl "https://www.bipm.org/en/publications/si-brochure"
        -- --         }
        -- --     , ChannelButton
        -- --         { label = "Dimensional Analysis, Percy Williams Bridgman, Yale University Press (1922)"
        -- --         , attributes = channelSubListButtonAttributes
        -- --         , onClick = NoOp -- LoadExternalUrl "http://books.google.com/books?id=pIlCAAAAIAAJ&dq=dimensional+analysis"
        -- --         }
        -- --     ]
        -- -- , ChannelButtonWithSubList
        -- --     { label = "QUDT in The News"
        -- --     , attributes = channelButtonAttributes
        -- --     , onClick = NoOp
        -- --     }
        -- --     [ ChannelButton
        -- --         { label = "The ABCs of QUDT - Blackwood"
        -- --         , attributes = channelSubListButtonAttributes
        -- --         , onClick = NoOp -- LoadExternalUrl "https://www.semanticarts.com/the-abcs-of-qudt/"
        -- --         }
        -- --     , ChannelButton
        -- --         { label = "The QUDT System for Dimensional Analysis and Unit Conversions - Winston)"
        -- --         , attributes = channelSubListButtonAttributes
        -- --         , onClick = NoOp -- LoadExternalUrl "https://donnywinston.com/posts/the-qudt-system-for-dimensional-analysis-and-unit-conversions/"
        -- --         }
        -- --     , ChannelButton
        -- --         { label = "Semantic Web for the Working Ontologist - Allemang, Hendler, Gandon"
        -- --         , attributes = channelSubListButtonAttributes
        -- --         , onClick = NoOp -- LoadExternalUrl "http://workingontologist.org/"
        -- --         }
        --     ]
        -- ]
        (domainContentsPane sharedModel <| "**QUDT**: **Q**uantity Kinds, **U**nits, **D**imensions, and **T**ypes")


domainContentsPane : Shared.Model -> String -> List (Element SharedMsg)
domainContentsPane sharedModel channel =
    [ mastHeader channel
        [ { label = "Home"
          , attributes = mastButtonAttributes
          , onClick = NoOp -- GoHome SHACLbuiltState
          }
        , { label = "Overview"
          , attributes = mastButtonAttributes
          , onClick = NoOp -- NoOp -- LoadExternalUrl "http://www.qudt.org/pages/QUDToverviewPage.html"
          }
        , { label = "Catalog"
          , attributes = mastButtonAttributes
          , onClick = NoOp -- LoadExternalUrl "http://www.qudt.org/2.1/catalog/qudt-catalog.html"
          }
        , { label = "About"
          , attributes = mastButtonAttributes
          , onClick = NoOp -- LoadExternalUrl "https://www.qudt.org/pages/AboutQUDTpage.html#"
          }
        , { label = "Contact"
          , attributes = mastButtonAttributes
          , onClick = NoOp -- LoadExternalUrl "http://www.qudt.org/pages/QUDTcontactsPage.html"
          }
        , { label = "Join"
          , attributes = mastButtonAttributes
          , onClick = NoOp -- LoadExternalUrl "http://www.qudt.org/pages/JoinQUDTpage.html"
          }
        , { label = "Donate"
          , attributes = mastButtonAttributes
          , onClick = NoOp -- LoadExternalUrl "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=HPQG536BSRNB4&source=url"
          }
        ]
    , canvasContent Nothing (domainContentsPaneContent sharedModel)
    ]


domainContentsPaneContent : Shared.Model -> List (Element msg)
domainContentsPaneContent sharedModel =
    [ column
        [ paddingXY 20 20
        , width fill
        , spacingXY 0 5
        ]
        [ column
            [ paddingXY 10 10
            , Background.color color.lightBlue
            , Border.solid
            , Border.width 2
            , Border.color color.darkBlue
            , Border.rounded 16
            ]
            [ paragraph [] [ markdownToElmUI domainOverview ]
            ]
        , column [ paddingXY 0 20, spacingXY 0 20 ]
            (contentBlocks
                |> List.map (\( h, c ) -> renderContentBlock h c)
            )
        ]
    ]


renderContentBlock : String -> String -> Element msg
renderContentBlock header content =
    column []
        [ el
            [ Font.size 24
            , Font.bold
            , Font.color color.darkBlue
            , spacingXY 0 10
            ]
          <|
            text header
        , paragraph [ spacingXY 10 0 ]
            [ markdownToElmUI content
            ]
        ]


contentBlocks : List ( String, MarkdownString )
contentBlocks =
    [ whyQUDT, useCases, qudtBrief, qudtBaseURIs, currentActivities, governance, qudtLicensing ]


domainOverview : MarkdownString
domainOverview =
    """
**QUDT.org** is a 501(c)(3) public charity nonprofit organization founded to provide semantic specifications for units of measure, quantity kind, dimensions and data types. 
QUDT is an advocate for the development and implementation of standards to quantify data expressed in RDF and JSON. 
Our mission is to improve interoperability of data and the specification of information structures through industry standards for Units of Measure, Quantity Kinds, Dimensions and Data Types.

QUDT.org operates thanks to volunteers, but we do have infrastructural costs of course. If you value the QUDT ontologies as a resource available to all, please consider a [donation]("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=HPQG536BSRNB4&source=url") of any amount (tax deductible in the USA). That will allow us to keep going and growing.
"""


whyQUDT : ( String, MarkdownString )
whyQUDT =
    ( "Why QUDT"
    , """
**QUDT.org** exists to make the QUDT Ontologies, derived models and vocabularies available to the public. 
Originally, QUDT models were developed for the NASA Exploration Initiatives Ontology Models (NExIOM) project,
 a Constellation Program initiative at the AMES Research Center (ARC).

**QUDT** has an extensive list of Units and Quantity Kinds that are fully specified with dimensions.
QUDT models are based on dimensional analysis expressed in the W3C [SHACL](https://www.w3.org/TR/shacl/) Shapes Constraints Language and also the W3C [OWL](http://www.w3.org/2004/OWL/) Web Ontology Language.
The dimensional approach relates each unit to a system of base units using numeric factors and a vector of exponents defined over a set of fundamental dimensions. In this way, the role of each base unit in the derived unit is precisely defined. A further relationship establishes the semantics of units and quantity kinds. By this means, QUDT supports reasoning over quantity kinds as well as units. 
QUDT models may be translated into other representations for machine processing, or other programming language structures according to need.
Cross references are specified to other vocabularies.

The **QUDT.org** website supports **Profiles** for generating community-relevant subsets of QUDT.
More on **Profiles** can be found [here]().
"""
    )


useCases : ( String, MarkdownString )
useCases =
    ( "Use Cases Benefitting From QUDT"
    , """
QUDT is more than a set of vocabularies representing the various quantity and unit standards.
It can be used to solve problems. Some of the associated use cases are itemized below:

* Conversion between single and complex unit types;
* Dimensional analysis of equations;
* Finding out equivalent units in different systems of units;
* Finding out equivalent quantity kinds in different systems of quantities.

"""
    )


qudtBrief : ( String, MarkdownString )
qudtBrief =
    ( "QUDT Overview"
    , """
QUDT ontologies are organized as collections of different types of graphs, as listed in the QUDT catalog. 
Vocabulary graphs hold different domains of quantities and units, which import the appropriate QUDT schemas. 
The core schema of QUDT imports the 
[VAEM](http://www.linkedmodel.org/doc/vaem/1.2/index.html), 
[DTYPE](https://linkedmodel.org/doc/dtype/1.0/) and [SKOS](https://www.w3.org/2009/08/skos-reference/skos.html) ontologies.

The core design pattern of the QUDT ontology is shown here:

![QUDT Design Pattern](https://github.com/qudt/qudt-public-repo/wiki/Quantity_Triad_Pattern.png "QUDT Schema Model Overview")
 """
    )


currentActivities : ( String, MarkdownString )
currentActivities =
    ( "Current Activities"
    , """
Please see our Announcements Page on GitHub

"""
    )


qudtBaseURIs : ( String, MarkdownString )
qudtBaseURIs =
    ( "QUDT Base URIs"
    , """
The DOI reference for citations of QUDT is at: [DOI.org](https://doi.org/10.25504/FAIRsharing.d3pqw7)

The table below provides the Base URIs for these ontologies.
They are linked to their respective catalog pages.

| Ontology | Base URI | Catalog Link |
|----------|----------|:------------:|
| OWL QUDT Ontology | [ "http://qudt.org/2.1/schema/qudt"](http://qudt.org/2.1/schema/qudt)| [&#8594;](../../)|
| SHACL QUDT Ontology | [ "http://qudt.org/2.1/schema/shacl/qudt"](http://qudt.org/2.1/schema/shacl/qudt)|[&#8594;](../../)|
| [QUDT Units Vocabulary](../../)| [ "http://qudt.org/2.1/vocab/unit"](http://qudt.org/2.1/vocab/unit)|[&#8594;](?domain=units)|
| QUDT QuantityKinds Vocabulary | [ "http://qudt.org/2.1/vocab/quantitykind"](http://qudt.org/2.1/vocab/quantitykind)|[&#8594;](../../)|
| QUDT DimensionVectors Vocabulary| [ "http://qudt.org/2.1/vocab/dimensionvector"](http://qudt.org/2.1/vocab/dimensionvector)|[&#8594;](../../)|
| QUDT Physical Constants Vocabulary | [ "http://qudt.org/2.1/vocab/constant"](http://qudt.org/2.1/vocab/constant)|[&#8594;](../../)|
| QUDT Systems of Units Vocabulary | [ "http://qudt.org/2.1/vocab/sou"](http://qudt.org/2.1/vocab/sou)|[&#8594;](../../)|
| QUDT Systems of Quantity Kinds Vocabulary | [ "http://qudt.org/2.1/vocab/soqk"](http://qudt.org/2.1/vocab/soqk)|[&#8594;](../../)|
| QUDT Datatype Ontology | [ "http://qudt.org/2.1/schema/datatype"](http://qudt.org/2.1/schema/datatype)| [&#8594;](../../)| 

***Warning!*** Files downloaded from the catalog may not be the latest versions. 
The master set of files is maintained in our [Github repository](http://github.com/qudt/qudt-public-repo).
The repository also contains additional files that are under development.
"""
    )


governance : ( String, MarkdownString )
governance =
    ( "Governance"
    , """
QUDT is governed by a board of directors from different organizations.
Governance is about establishing information artifacts, organizational structures, processes, policies and measures that help achieve strong participation for critical decisions affecting QUDT entities, properties and values.
Governance groups, based perhaps on profiles, may be established for specific purposes, such as selecting subsets of units interoperability.

*Last Updated March 1, 2022*

  """
    )


qudtLicensing : ( String, MarkdownString )
qudtLicensing =
    ( "Licensing"
    , """
**QUDT** is licensed under a [Creative Commons Attribution 4.0 International License]("https://creativecommons.org/licenses/by/4.0/").

"""
    )


testMD : MarkdownString
testMD =
    """
# Note: Just a Test for now

**InteroptX** has built and reused many ontologies based on both OWL and SHACL.
Our passion is in solving hard problems that require:

* Advanced data modeling for reusable component ontologies and support for aspects/traits
* Functional programming idioms
* Commodity tools and libraries
* Modern software engineering practices for:
  * Rapid iteration, 
  * Test-driven development,
  * High quality APIs,
  * Continuous Integration and Deployment

We work with both functional programming and imperative programming approaches for 
knowledge graphs in the following languages, and tools:

* Java, [Scala](https://www.scala-lang.org/), Haskell, Python, JavaScript, TypeScript, [Elm](https://elm-lang.org/)
* [TopBraid](https://www.topquadrant.com/), [Jena](https://jena.apache.org/), [Fuseki](https://jena.apache.org/documentation/fuseki2/), [GraphDB](https://www.ontotext.com/products/graphdb/)
* Visual Studio, [IntelliJ](https://www.jetbrains.com/idea/), GitHub


"""
