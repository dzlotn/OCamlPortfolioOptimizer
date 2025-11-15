type series = float list
(** This calculates risk metrics for each stock*)

type stock = {
  ticker : string;
  prices : series;
}

type return_series = float list

type summary = {
  avg_price : float;
  cumulative_return : float;
  volatility : float;
  max_drawdown : float;
  sharpe : float;
}

exception Empty_series
exception Length_mismatch of string

let len_list lst = List.length lst

let avg xs =
  match xs with
  | [] -> raise Empty_series
  | _ ->
      let sum = List.fold_left ( +. ) 0.0 xs in
      let count = float_of_int (List.length xs) in
      sum /. count

let sum_of_squares lst =
  match lst with
  | [] -> raise Empty_series
  | _ ->
      let m = avg lst in
      List.fold_left
        (fun acc x ->
          let d = x -. m in
          acc +. (d *. d))
        0.0 lst

let variance lst =
  match lst with
  | [] -> raise Empty_series
  | _ ->
    let sos = sum_of_squares lst in
    let n = float_of_int (List.length lst) in
    sos /. n

let standard_deviation lst =
  let v = variance lst in
  sqrt (v)


(*Gets lst of prices and returns a lst of percent diffs*)
let simple_return_ratio lst =
  match lst with
  | [] | [_] -> raise Empty_series
  | _ ->
      let rec aux prev xs =
        match xs with
        | [] -> []
        | p :: tl ->
            let r = (p -. prev) /. prev in
            r :: aux p tl
      in
      aux (List.hd lst) (List.tl lst)

(*Gets lst of prices and returns lst of logged percent diffs called simple returns*)
let log_return_ratio lst =
  match lst with
  | [] | [_] -> raise Empty_series
  | _ ->
      let rec aux prev xs =
        match xs with
        | [] -> []
        | p :: tl ->
            let r = log (p /. prev) in
            r :: aux p tl
      in
      aux (List.hd lst) (List.tl lst)

(*Gets the cumulative return ratio over the entire lifetime*)
let cumulative_return lst =
  match lst with
  | [] -> raise Empty_series
  | _ ->
      let first = List.hd lst in
      let last = List.hd (List.rev lst) in
      (last -. first) /. first

(*Volatility over one-year period*)
let annualized_volatility returns =
  let sd = standard_deviation returns in
  sd *. sqrt 252.0
