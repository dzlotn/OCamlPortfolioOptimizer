(* Shared questionnaire types *)
type investment_goal =
  | Growth
  | Income
  | Balanced
  | Preservation

type investment_experience =
  | Beginner
  | Intermediate
  | Experienced

type risk_tolerance =
  | Conservative
  | Moderate
  | Aggressive

type time_horizon =
  | Short_term
  | Medium_term
  | Long_term

type portfolio_size =
  | Small
  | Medium
  | Large

type questionnaire_responses = {
  name : string;
  goal : investment_goal;
  experience : investment_experience;
  risk : risk_tolerance;
  horizon : time_horizon;
  portfolio_size : portfolio_size;
  willing_to_lose : bool;
  has_current_investments : bool;
  current_investments : string list option;
}

(* parsing the user's investment goal *)
let parse_goal input =
  match String.lowercase_ascii input with
  | "1" | "growth" -> Some Growth
  | "2" | "income" -> Some Income
  | "3" | "balanced" -> Some Balanced
  | "4" | "preservation" -> Some Preservation
  | _ -> None

(* parsing the user's investment experience *)
let parse_experience input =
  match String.lowercase_ascii input with
  | "1" | "beginner" -> Some Beginner
  | "2" | "intermediate" -> Some Intermediate
  | "3" | "experienced" -> Some Experienced
  | _ -> None

(* parsing the user's risk tolerance *)
let parse_risk input =
  match String.lowercase_ascii input with
  | "1" | "conservative" -> Some Conservative
  | "2" | "moderate" -> Some Moderate
  | "3" | "aggressive" -> Some Aggressive
  | _ -> None

(* parsing the user's time horizon *)
let parse_horizon input =
  match String.lowercase_ascii input with
  | "1" | "short-term" | "short" -> Some Short_term
  | "2" | "medium-term" | "medium" -> Some Medium_term
  | "3" | "long-term" | "long" -> Some Long_term
  | _ -> None

(* parsing the user's portfolio size *)
let parse_portfolio_size input =
  match String.lowercase_ascii input with
  | "1" | "small" -> Some Small
  | "2" | "medium" -> Some Medium
  | "3" | "large" -> Some Large
  | _ -> None

(* parsing the user's yes/no response *)
let parse_yes_no input =
  match String.lowercase_ascii input with
  | "yes" | "y" | "true" | "1" -> Some true
  | "no" | "n" | "false" | "2" -> Some false
  | _ -> None
