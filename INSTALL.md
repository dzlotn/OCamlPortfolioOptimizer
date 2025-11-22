## Getting Everything to Work

1. **Installation**
   First, git clone or fork the repository onto your own computer


2. **Install OCaml dependencies (one time)**

   ```bash
   opam install cohttp-lwt-unix yojson lwt lwt_ppx lwt_ssl
   ```

   These packages give us HTTPS support plus JSON parsing.

3. **Set your Alpha Vantage key**

   Create a free API key at Alpha Vantage and export it before running the demo:

   ```bash
   export ALPHAVANTAGE_API_KEY=your_key_here
   ```

   Keeping the key in an environment variable avoids checking secrets into git.

4. **Run the demo executable**

   ```bash
   dune exec bin/main.exe
   ```

If you need to adjust the tickers or throttle behavior, edit `diversified_symbols`
and `throttle_seconds` near the top of `bin/api.ml`, then rerun the command above.





## Unfinished: Installing GUI Library: Bogue
$ opam install bogue

Install anything else required if prompted