# How to Run the Portfolio Optimizer

## Prerequisites

1. **Install OCaml dependencies** (if not already installed):
   ```bash
   opam install cohttp-lwt-unix yojson lwt lwt_ppx lwt_ssl bogue
   ```

2. **Install SDL2 libraries** (required for GUI):
   ```bash
   # On Ubuntu/Debian:
   sudo apt-get install libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev

   # On macOS (with Homebrew):
   brew install sdl2 sdl2_image sdl2_ttf
   ```

3. **Set your Alpha Vantage API key**:
   ```bash
   export ALPHAVANTAGE_API_KEY=your_key_here
   ```

   Get a free API key from: https://www.alphavantage.co/support/#api-key

## Building the Project

```bash
dune build
```

This will compile all the modules and create the executable.

## Running the System

### Step 1: Refresh the Stock Cache (Recommended First)

Before running the questionnaire, you should populate the stock cache with data:

```bash
# Refresh all default stocks (20 stocks, takes ~5 minutes)
dune exec -- FinalProject-refresh

# Or refresh specific stocks (faster for testing)
dune exec -- FinalProject-refresh AAPL,MSFT,GOOGL

# Note: You can also use the main executable:
# dune exec -- FinalProject refresh AAPL,MSFT,GOOGL
# (This internally calls FinalProject-refresh)
```

This will:
- Fetch historical data for each stock from the Alpha Vantage API
- Analyze each stock (calculate volatility, Sharpe ratio, max drawdown, etc.)
- Save the results to `stock_cache.json`

**Note:** The free Alpha Vantage API has rate limits (5 requests per minute), so the refresh command waits 15 seconds between each stock. For 20 stocks, this takes about 5 minutes.

### Step 2: Run the Questionnaire

```bash
dune exec -- FinalProject
```

This will:
1. Ask you a series of questions about your investment preferences
2. Calculate your risk profile based on your answers
3. Check your current investments (if any) against your risk profile
4. If you enter stocks not in the cache, it will fetch them from the API automatically
5. Provide personalized stock recommendations that match your risk profile

### Step 3: Run with GUI (Optional)

```bash
dune exec -- FinalProject gui
```

This opens a graphical interface instead of the command-line questionnaire.

## Example Workflow

```bash
# 1. Set API key
export ALPHAVANTAGE_API_KEY=your_key_here

# 2. Build the project
dune build

# 3. Refresh cache with a few stocks for testing
dune exec -- FinalProject refresh AAPL,MSFT,GOOGL,NVDA

# 4. Run the questionnaire
dune exec -- FinalProject
```

## Understanding the Output

After completing the questionnaire, you'll see:

1. **Your Risk Profile**:
   - Risk Score (0.0 = conservative, 1.0 = aggressive)
   - Target Volatility
   - Minimum Sharpe Ratio
   - Max Drawdown Tolerance
   - Portfolio Size

2. **Current Investment Analysis**:
   - For each stock you own, it shows whether it matches your risk profile
   - If a stock doesn't match, it explains why (e.g., too volatile, low Sharpe ratio)

3. **Stock Recommendations**:
   - A list of stocks that match your risk profile
   - Each recommendation includes:
     - Match score
     - Reason why it's recommended
     - Key metrics (volatility, Sharpe ratio, max drawdown)

## Troubleshooting

- **"Set the ALPHAVANTAGE_API_KEY environment variable"**: Make sure you've exported your API key
- **"No recommendations available"**: Run the `refresh` command first to populate the cache
- **API rate limit errors**: Wait a few minutes and try again, or use the refresh command with fewer stocks

