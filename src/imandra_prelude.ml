type ('ok, 'e) result =
| Ok of 'ok
| Error of 'e

module Z = struct
  let of_string = int_of_string
  let to_string = string_of_int
  let pp_print = string_of_int
  let of_int s = s
end

#402 "prelude.iml"
module List =
struct
  type 'a t = 'a list
  let empty = []
  let is_empty = function | [] -> true | _::_ -> false
  [@@ocaml.doc " Test whether a list is empty "]
  let cons x y = x :: y
  [@@ocaml.doc
    " [cons x l] prepends [x] at the beginning of [l], returning a new list "]
  let return x = [x] [@@ocaml.doc " Singleton list "]
  let hd = List.hd
  [@@ocaml.doc
    " Partial function to access the head of the list.\n      This function will fail when applied to the empty list.\n      {b NOTE} it is recommended to rely on pattern matching instead "]
  let tl = List.tl
  [@@ocaml.doc
    " Partial function to access the tail of the list.\n      This function will fail when applied to the empty list\n      {b NOTE} it is recommended to rely on pattern matching instead "]
  let rec append l1 l2 =
    match l1 with
      | [] -> l2
      | x::l1' -> x :: (append l1' l2)
  [@@ocaml.doc
    " Concatenation. [append l1 l2] returns a list composed of all\n      the elements of [l1], followed by all the elements of [l2] "]
  let rec rev l =
    match l with
      | [] -> []
      | x::l' -> append (rev l') [x]
  [@@ocaml.doc " Reverse a list "]
  let rec length l =
    match l with
      | [] -> Z.of_string "0"
      | _::l2 -> (Z.of_string "1") + (length l2)
  [@@ocaml.doc
    " Compute the length of a list. Linear time. "]
  let len_nonnegative l =
    ((length l)[@trigger ]) >= (Z.of_string "0")
  [@@theorem ][@@fc ][@@induct ]
  let len_zero_is_empty x =
    ((length x) = (Z.of_string "0")) = (x = [])
  [@@theorem ][@@rewrite ][@@induct ]
  let rec split l =
    match l with
      | [] -> ([], [])
      | (x,y)::tail ->
        let (tail1,tail2) = split tail  in
        ((x :: tail1), (y :: tail2))
  [@@ocaml.doc
    " Split a list of pairs into a pair of lists "]
  let rec map f l =
    match l with
      | [] -> []
      | x::l2 -> (f x) :: (map f l2)
  [@@ocaml.doc
    " Map a function over a list.\n\n      - [map f [] = []]\n      - [map f [x] = [f x]]\n      - [map f (x :: tail) = f x :: map f tail]\n  "]
  let rec for_all f l =
    match l with
      | [] -> true
      | x::l2 -> (f x) && (for_all f l2)
  [@@ocaml.doc
    " [for_all f l] tests whether all elements of [l] satisfy the predicate [f] "]
  let rec exists f l =
    match l with
      | [] -> false
      | x::l2 -> (f x) || (exists f l2)
  [@@ocaml.doc
    " [exists f l] tests whether there is an element of [l]\n      that satisfies the predicate [f] "]
  let rec fold_left f acc =
    function
      | [] -> acc
      | x::tail -> fold_left f (f acc x) tail
  [@@ocaml.doc
    " Fold-left, with an accumulator that makes induction more challenging "]
  let rec fold_right f ~base  l =
    match l with
      | [] -> base
      | x::tail -> f x (fold_right f ~base tail)
  [@@ocaml.doc
    " Fold-right, without accumulator. This is generally more friendly for\n      induction than [fold_left]. "]
  let rec filter f =
    function
      | [] -> []
      | x::tail ->
        let tail = filter f tail  in
        if f x then x :: tail else tail
  [@@ocaml.doc
    " [filter f l] keeps only the elements of [l] that satisfy [f]. "]
  let rec filter_map f =
    function
      | [] -> []
      | x::tail ->
        let tail = filter_map f tail  in
        (match f x with
          | None  -> tail
          | Some y -> y :: tail)

  let rec flat_map f =
    function
      | [] -> []
      | x::tail -> append (f x) (flat_map f tail)
  let rec mem x =
    function
      | [] -> false
      | y::tail -> (x = y) || (mem x tail)
  [@@ocaml.doc
    " [mem x l] returns [true] iff [x] is an element of [l] "]
  let rec mem_assoc x =
    function
      | [] -> false
      | (k,_)::tail -> (x = k) || (mem_assoc x tail)
  let rec nth n =
    function
      | [] -> None
      | y::tail ->
        if n = (Z.of_string "0")
        then Some y
        else nth (n - (Z.of_string "1")) tail

  let rec assoc x =
    function
      | [] -> None
      | (k,v)::tail ->
        if x = k then Some v else assoc x tail

  let rec take n =
    function
      | [] -> []
      | _ when n <= (Z.of_string "0") -> []
      | x::tl -> x :: (take (n - (Z.of_string "1")) tl)
  [@@ocaml.doc
    " [take n l] returns a list composed of the first (at most) [n] elements\n      of [l]. If [length l <= n] then it returns [l] "]
  let rec drop n =
    function
      | [] -> []
      | l when n <= (Z.of_string "0") -> l
      | _::tl -> drop (n - (Z.of_string "1")) tl
  [@@ocaml.doc
    " [drop n l] returns [l] where the first (at most) [n] elements\n      have been removed. If [length l <= n] then it returns [[]] "]
  let rec (--) i j =
    if i >= j
    then []
    else i :: ((i + (Z.of_string "1")) -- j)
  [@@ocaml.doc
    " Integer range. [i -- j] is the list [[i; i+1; i+2; \226\128\166; j-1]].\n      Returns the empty list if [i >= j]. "]
  let rec insert_sorted ~leq  x l =
    match l with
      | [] -> [x]
      | y::_ when leq x y -> x :: l
      | y::tail -> y :: (insert_sorted ~leq x tail)
  [@@ocaml.doc
    " Insert [x] in [l], keeping [l] sorted. "]
  let sort ~leq  l =
    (fold_left
       (fun acc  -> fun x  -> insert_sorted ~leq x acc)
       [] l : _ list)
  [@@ocaml.doc " Basic sorting function "]
  let rec is_sorted ~leq  =
    function
      | []|_::[] -> true
      | x::(y::_ as tail) ->
        (leq x y) && (is_sorted ~leq tail)
  [@@ocaml.doc
    " Check whether a list is sorted, using the [leq] small-or-equal-than\n      predicatet "]
end[@@ocaml.doc
  " {2 List module}\n\n    This module contains many safe functions for manipulating lists.\n"]

#582 "prelude.iml"
let (@) = List.append
[@@ocaml.doc " Infix alias to {!List.append} "]

#585 "prelude.iml"
let (--) = List.(--) [@@ocaml.doc " Alias to {!List.--} "]

#587 "prelude.iml"
module Int =
struct
  type t = int
  let (+) = (+)
  let (-) = (-)
  let (~-) = (~-)
  let ( * ) = ( * )
  let (/) = (/)
  let (mod) = (mod)
  let (<) = (<)
  let (<=) = (<=)
  let (>) = (>)
  let (>=) = (>=)
  let min = min
  let max = max
  let to_string : t -> string = Z.to_string
  [@@ocaml.doc
    " Conversion to a string.\n      Only works for nonnegative numbers "]
  let compare (x : t) (y : t) =
    if x = y
    then Z.of_string "0"
    else
    if x < y
    then Z.of_string "-1"
    else Z.of_string "1"

  let equal = (=)
  let compare = Pervasives.compare [@@program ]
  let pp = Z.pp_print [@@program ]
  let of_caml_int = Z.of_int [@@program ]
end

#625 "prelude.iml"
module Option =
struct
  type 'a t = 'a option
  let map f =
    function | None  -> None | Some x -> Some (f x)
  [@@ocaml.doc
    " Map over the option.\n\n      - [map f None = None]\n      - [map f (Some x) = Some (f x)]\n  "]
  let map_or ~default  f =
    function | None  -> default | Some x -> f x
  let is_some =
    function | None  -> false | Some _ -> true
  [@@ocaml.doc
    " Returns [true] iff the argument is of the form [Some x] "]
  let is_none =
    function | None  -> true | Some _ -> false
  [@@ocaml.doc
    " Returns [true] iff the argument is [None] "]
  let return x = Some x
  [@@ocaml.doc
    " Wrap a value into an option. [return x = Some x] "]
  let (>|=) x f = map f x
  [@@ocaml.doc " Infix alias to {!map} "]
  let (>>=) o f =
    match o with | None  -> None | Some x -> f x
  [@@ocaml.doc
    " Infix monadic operator, useful for chaining multiple optional computations\n      together.\n\n      It holds that [(return x >>= f) = f x] "]
  let or_ ~else_  a =
    match a with | None  -> else_ | Some _ -> a
  [@@ocaml.doc
    " Choice of a value\n\n      - [or_ ~else_:x None = x]\n      - [or_ ~else_:x (Some y) = Some y]\n  "]
  let (<+>) a b = or_ ~else_:b a
  let exists p =
    function | None  -> false | Some x -> p x
  let for_all p =
    function | None  -> true | Some x -> p x
  let get_or ~default  x =
    match x with | None  -> default | Some y -> y
  let fold f acc o =
    match o with | None  -> acc | Some x -> f acc x
end[@@ocaml.doc
  " {2 Option module}\n\n    The option type [type 'a option = None | Some of 'a] is useful for\n    representing partial functions and optional values.\n    "]

#712 "prelude.iml"
module Result =
struct
  type ('a,'b) t = ('a,'b) result
  let return x = Ok x
  let fail s = Error s
  let map f e =
    match e with | Ok x -> Ok (f x) | Error s -> Error s
  let map_err f e =
    match e with
      | Ok _ as res -> res
      | Error y -> Error (f y)
  let get_or e ~default  =
    match e with | Ok x -> x | Error _ -> default
  let map_or f e ~default  =
    match e with | Ok x -> f x | Error _ -> default
  let (>|=) e f = map f e
  let flat_map f e =
    match e with | Ok x -> f x | Error s -> Error s
  let (>>=) e f = flat_map f e
  let fold ~ok  ~error  x =
    match x with | Ok x -> ok x | Error s -> error s
  let is_ok = function | Ok _ -> true | Error _ -> false
  let is_error =
    function | Ok _ -> false | Error _ -> true
end


#1210 "prelude.iml"
let succ x = x + (Z.of_string "1")
[@@ocaml.doc " Next integer "]

#1213 "prelude.iml"
let pred x = x - (Z.of_string "1")
[@@ocaml.doc " Previous integer "]

#1215 "prelude.iml"
let fst (x,_) = x

#1216 "prelude.iml"
let snd (_,y) = y

let (%>) f g x = g (f x)
