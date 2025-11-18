open Bogue
module W = Widget
module L = Layout

let quiz_answers = ref []
let set_layout widget height = L.resident ~w:500 ~h:height widget

let horizontal_radiolist labels =
  let pairs = List.map W.check_box_with_label labels in
  let checks = List.map fst pairs in
  let layouts =
    List.map (fun (check, label) -> L.flat_of_w [ check; label ]) pairs
  in
  (Radiolist.of_widgets checks, L.flat layouts)

let radio_question question =
  let question_layout = set_layout question 70 in
  let radiolist, row_layout = horizontal_radiolist [ "1"; "2"; "3" ] in
  let answer = L.flat [ row_layout ] in
  (L.flat ~align:Draw.Center ~hmargin:200 [ question_layout; answer ], radiolist)

let q1 () =
  let question_layout = set_layout (W.label "1.  What is your name?") 20 in
  let blank = L.resident ~w:200 ~h:20 (W.label "") in

  let answer = W.text_input ~max_size:50 () in
  let answer_layout = L.resident ~w:200 answer in
  ( L.flat ~align:Draw.Min ~hmargin:20 [ question_layout; blank; answer_layout ],
    answer )

let q2 () =
  let question =
    W.text_display
      "2.  What is your primary investment goal?\n\
      \          1. Growth (capital appreciation)\n\
      \          2. Income (dividend/regular income)\n\
      \          3. Balanced (growth and income)\n\
      \          4. Preservation (protect capital)"
  in
  let question_layout = set_layout question 90 in
  let radiolist, row_layout = horizontal_radiolist [ "1"; "2"; "3"; "4" ] in
  let answer = L.flat [ row_layout ] in
  (L.flat ~align:Draw.Center ~hmargin:200 [ question_layout; answer ], radiolist)

let q3 () =
  W.text_display
    "3.  How experienced are you with stock investing?\n\
    \          1. Beginner\n\
    \          2. Intermediate\n\
    \          3. Experienced"
  |> radio_question

let q4 () =
  W.text_display
    "4.  How would you describe your risk tolerance?\n\
    \          1. Conservative (low risk, stable returns)\n\
    \          2. Moderate (balanced risk and return)\n\
    \          3. Aggressive (high risk, higher potential returns)"
  |> radio_question

let q5 () =
  W.text_display
    "5.  What is your investment time horizon?\n\
    \          1. Short-term (1-3 years)\n\
    \          2. Medium-term (3-7 years)\n\
    \          3. Long-term (7+ years)"
  |> radio_question

let q6 () =
  W.text_display
    "6.  How many stocks would you like for diversification?\n\
    \          1. Small (3-5 stocks)\n\
    \          2. Medium (5-10 stocks)\n\
    \          3. Large (10+ stocks)"
  |> radio_question

let q7 () =
  let question_layout =
    set_layout
      (W.label
         "7.  Are you willing to invest in assets that may temporarily lose \
          money?")
      20
  in
  let blank = L.resident ~w:23 ~h:20 (W.label "") in
  let radiolist, row_layout = horizontal_radiolist [ "Yes"; "No" ] in
  let answer = L.flat [ row_layout ] in
  ( L.flat ~align:Draw.Center ~hmargin:172 [ question_layout; blank; answer ],
    radiolist )

let q8 () =
  let question_layout =
    set_layout (W.label "8.   Do you currently have investments?") 20
  in
  let blank = L.resident ~w:121 ~h:20 (W.label "") in
  let radiolist, row_layout = horizontal_radiolist [ "Yes"; "No" ] in
  let answer = L.flat [ row_layout ] in
  ( L.flat ~align:Draw.Center ~hmargin:75 [ question_layout; blank; answer ],
    radiolist )

let q9 () =
  let question_layout =
    set_layout
      (W.text_display
         "9.  If yes, please list your current investments.\n\
          (ticker symbols, separated by commas)")
      20
  in
  let blank = L.resident ~w:20 ~h:20 (W.label "") in

  let answer = W.text_input ~max_size:1000 () in
  let answer_layout = L.resident ~w:500 answer in
  ( L.flat ~align:Draw.Min ~hmargin:202 [ question_layout; blank; answer_layout ],
    answer )

let submit () =
  let submit =
    W.button ~border_radius:15 ~label:(Label.create ~size:15 "Submit") ""
  in
  ( submit,
    L.flat ~align:Draw.Center
      [ L.resident ~w:1100 ~h:30 (W.label ""); L.resident submit ] )

let check_investments curr =
  let investments =
    curr |> String.split_on_char ',' |> List.map String.trim
    |> List.filter (fun s -> s <> "")
  in
  investments = []

let check_filled name radios inves curr =
  W.get_text name <> ""
  && List.for_all (fun r -> Radiolist.get_index r <> None) radios
  && not
       (Radiolist.get_index inves = Some 0
       && W.get_text curr = ""
       && check_investments (W.get_text curr))

let show_missing_popup layout =
  Popup.info ~w:200 ~h:50 "ANSWERS MISSING\nPlease answer all questions." layout

let set_answers name goal exp risk horizon size willing inves curr =
  let get_value x = string_of_int (Option.get (Radiolist.get_index x) + 1) in
  let investments =
    if Radiolist.get_index inves = Some 1 then "" else W.get_text curr
  in
  quiz_answers :=
    [
      W.get_text name;
      get_value goal;
      get_value exp;
      get_value risk;
      get_value horizon;
      get_value size;
      get_value willing;
      get_value inves;
      investments;
    ]

let questions next_page =
  let heading =
    L.flat_of_w ~align:Draw.Min
      [ W.label ~size:30 "     Please answer the following questions:" ]
  in
  let name, input = q1 () in
  let goal, q2 = q2 () in
  let exp, q3 = q3 () in
  let risk, q4 = q4 () in
  let hor, q5 = q5 () in
  let size, q6 = q6 () in
  let will, q7 = q7 () in
  let inves, q8 = q8 () in
  let curr, q9 = q9 () in
  let submit, submit_layout = submit () in
  let content =
    L.tower
      [
        heading;
        name;
        goal;
        exp;
        risk;
        hor;
        size;
        will;
        inves;
        curr;
        submit_layout;
      ]
  in
  let layout = L.make_clip ~h:500 content in
  let submit_form _widget =
    if not (check_filled input [ q2; q3; q4; q5; q6; q7 ] q8 q9) then
      show_missing_popup layout
    else (
      set_answers input q2 q3 q4 q5 q6 q7 q8 q9;
      Layout.set_rooms layout [ next_page ])
  in
  W.on_button_release ~release:submit_form submit;
  layout

let homepage next_page =
  let title = W.label ~size:50 "=== Portfolio Optimizer Quiz ===" in
  let button_label = Label.create ~size:32 "START" in
  let button = W.button ~border_radius:15 ~label:button_label "" in
  let welcome =
    W.label ~size:32 "Welcome! Let's find the perfect portfolio for you."
  in
  let instructions = W.label ~size:32 "Click [START] to begin." in
  let title_layout = L.flat_of_w ~align:Draw.Center [ title ] in
  let welcome_layout = L.resident welcome in
  let instructions_layout = L.resident instructions in
  let content =
    L.tower ~align:Draw.Center
      [ title_layout; welcome_layout; instructions_layout ]
  in
  let button_layout = L.resident ~w:200 ~h:50 button in
  let layout =
    L.tower ~vmargin:75 ~sep:65 ~align:Draw.Center [ content; button_layout ]
  in
  Layout.set_size layout ~w:1250 ~h:820;
  let switch_screens _widget = Layout.set_rooms layout [ next_page ] in
  Widget.on_button_release ~release:switch_screens button;
  layout

let endpage prev_page =
  let title = W.label ~size:50 "Thank you!" in
  let heading = W.label ~size:40 "Your responses have been recorded." in
  let button_label = Label.create ~size:32 "End" in
  let button = W.button ~border_radius:15 ~label:button_label "" in
  let title_layout = L.flat_of_w ~align:Draw.Center [ title ] in
  let heading_layout = L.flat_of_w ~align:Draw.Center [ heading ] in
  let button_layout = L.resident ~w:150 ~h:50 button in
  let layout =
    L.tower ~vmargin:200 ~sep:10 ~align:Draw.Center
      [ title_layout; heading_layout; button_layout ]
  in
  Layout.set_size layout ~w:1250 ~h:820;
  let end_quiz _widget = Trigger.push_quit () in
  Widget.on_button_release ~release:end_quiz button;
  layout

let run_gui () =
  let endpage = endpage () in
  Layout.set_size endpage ~w:1250 ~h:820;
  let questions = questions endpage in
  Layout.set_size questions ~w:1250 ~h:820;
  let layout = homepage questions in
  Layout.set_size layout ~w:1250 ~h:820;
  let board = Main.of_layout layout in
  Main.run board
