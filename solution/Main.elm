module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { tasks : List Task
    , textEntered : String
    }


type alias Task =
    { label : String
    , status : TaskStatus
    }


type TaskStatus
    = Active
    | Done


initialModel : Model
initialModel =
    { tasks =
        [ { label = "Read H2G2", status = Done }
        , { label = "Learn Haskell", status = Active }
        , { label = "Go to Tatooine", status = Active }
        ]
    , textEntered = ""
    }


type Msg
    = ClikedOnDoneButton Int
    | TextEntered String
    | TaskSubmitted


update : Msg -> Model -> Model
update msg model =
    case msg of
        ClikedOnDoneButton idx ->
            let
                transformTask : Int -> Task -> Task
                transformTask i task =
                    if idx == i then
                        { task | status = Done }

                    else
                        task
            in
            { model
                | tasks = List.indexedMap transformTask model.tasks
            }

        TextEntered t ->
            { model | textEntered = t }

        TaskSubmitted ->
            { model
                | textEntered = ""
                , tasks = { label = model.textEntered, status = Active } :: model.tasks
            }


view : Model -> Html Msg
view model =
    div []
        [ Html.form [ onSubmit TaskSubmitted, id "todo-form" ]
            [ input [ onInput TextEntered, type_ "text", value model.textEntered ] []
            , input [ type_ "submit", value "+" ] []
            ]
        , text "Tasks to do:"
        , ul [ class "tasks" ]
            (List.indexedMap viewTask model.tasks)
        ]


viewTask : Int -> Task -> Html Msg
viewTask idx task =
    case task.status of
        Active ->
            li [ class "hey" ]
                [ text task.label
                , button
                    [ class "done-button"
                    , onClick <| ClikedOnDoneButton idx
                    ]
                    [ text "Done !" ]
                ]

        Done ->
            li [ class "done" ] [ text task.label ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
