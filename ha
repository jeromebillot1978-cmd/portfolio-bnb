<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portfolio BNB - Dashboard Pro</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', sans-serif; 
            background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%); 
            color: #fff; 
            padding: 20px; 
            min-height: 100vh; 
        }
        .container { max-width: 1400px; margin: 0 auto; }
        
        .header { 
            background: linear-gradient(135deg, rgba(243, 186, 47, 0.1) 0%, rgba(0,0,0,0.6) 100%); 
            backdrop-filter: blur(10px);
            padding: 25px; 
            border-radius: 20px; 
            border: 2px solid rgba(243, 186, 47, 0.3); 
            margin-bottom: 20px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
        }
        
        h1 { 
            font-size: 2.2em; 
            text-align: center; 
            margin-bottom: 15px;
            background: linear-gradient(135deg, #f3ba2f 0%, #ffd700 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .status { 
            text-align: center; 
            padding: 15px; 
            background: rgba(255,255,255,0.05); 
            border-radius: 12px; 
            margin: 15px 0;
        }
        .status.connected { background: rgba(16, 185, 129, 0.15); border: 2px solid #10b981; }
        .status.disconnected { background: rgba(239, 68, 68, 0.15); border: 2px solid #ef4444; }
        
        button { 
            background: linear-gradient(135deg, #f3ba2f 0%, #d4a02a 100%); 
            color: #000; 
            border: none; 
            padding: 12px 35px; 
            border-radius: 12px; 
            font-size: 1em; 
            font-weight: bold; 
            cursor: pointer; 
            transition: all 0.3s; 
            margin: 5px;
            box-shadow: 0 4px 15px rgba(243, 186, 47, 0.3);
        }
        button:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(243, 186, 47, 0.5); }
        button:disabled { opacity: 0.5; cursor: not-allowed; }
        .btn-disconnect { background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); color: white; }
        .btn-swap { background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: white; }
        
        .dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .stat-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.08) 0%, rgba(255,255,255,0.03) 100%);
            backdrop-filter: blur(10px);
            padding: 25px;
            border-radius: 15px;
            border: 1px solid rgba(243, 186, 47, 0.2);
            box-shadow: 0 8px 32px rgba(0,0,0,0.2);
            transition: all 0.3s;
        }
        .stat-card:hover { 
            transform: translateY(-5px); 
            border-color: rgba(243, 186, 47, 0.5);
            box-shadow: 0 12px 40px rgba(243, 186, 47, 0.2);
        }
        
        .stat-label { 
            font-size: 0.9em; 
            color: #cbd5e1; 
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .stat-value { 
            font-size: 2em; 
            font-weight: bold; 
            color: #f3ba2f;
            margin-bottom: 5px;
        }
        .stat-change {
            font-size: 0.9em;
            padding: 5px 10px;
            border-radius: 8px;
            display: inline-block;
            margin-top: 10px;
        }
        .stat-change.positive { background: rgba(16, 185, 129, 0.2); color: #10b981; }
        .stat-change.negative { background: rgba(239, 68, 68, 0.2); color: #ef4444; }
        
        .chart-container {
            background: linear-gradient(135deg, rgba(255,255,255,0.08) 0%, rgba(255,255,255,0.03) 100%);
            backdrop-filter: blur(10px);
            padding: 25px;
            border-radius: 15px;
            border: 1px solid rgba(243, 186, 47, 0.2);
            margin-bottom: 20px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.2);
        }
        
        .wallet-info {
            background: linear-gradient(135deg, rgba(255,255,255,0.08) 0%, rgba(255,255,255,0.03) 100%);
            backdrop-filter: blur(10px);
            padding: 20px;
            border-radius: 15px;
            border: 1px solid rgba(243, 186, 47, 0.2);
            margin-bottom: 20px;
        }
        
        .info-row { 
            display: flex; 
            justify-content: space-between; 
            padding: 12px 0; 
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .info-row:last-child { border-bottom: none; }
        .label { color: #cbd5e1; }
        .value { color: #f3ba2f; font-weight: bold; font-family: monospace; }
        
        .swap-section { 
            background: linear-gradient(135deg, rgba(255,255,255,0.08) 0%, rgba(255,255,255,0.03) 100%);
            backdrop-filter: blur(10px);
            padding: 25px; 
            border-radius: 15px; 
            margin-top: 20px;
            border: 1px solid rgba(243, 186, 47, 0.2);
            box-shadow: 0 8px 32px rgba(0,0,0,0.2);
        }
        
        .message { 
            padding: 15px; 
            border-radius: 10px; 
            margin: 15px 0; 
            text-align: center; 
            font-weight: bold;
            backdrop-filter: blur(10px);
        }
        .error { background: rgba(239, 68, 68, 0.2); border: 2px solid #ef4444; }
        .success { background: rgba(16, 185, 129, 0.2); border: 2px solid #10b981; }
        .warning { background: rgba(245, 158, 11, 0.2); border: 2px solid #f59e0b; }
        
        .dex-selector {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 10px;
            margin: 20px 0;
        }
        .dex-btn {
            padding: 15px 10px;
            background: rgba(255,255,255,0.05);
            border: 2px solid rgba(243, 186, 47, 0.2);
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
        }
        .dex-btn:hover { 
            border-color: #f3ba2f; 
            transform: scale(1.05);
            box-shadow: 0 5px 20px rgba(243, 186, 47, 0.3);
        }
        .dex-btn.active { 
            background: rgba(243, 186, 47, 0.2); 
            border-color: #f3ba2f;
            box-shadow: 0 5px 20px rgba(243, 186, 47, 0.4);
        }
        .dex-name { font-size: 1.1em; font-weight: bold; margin-bottom: 5px; }
        .dex-fee { font-size: 0.85em; color: #10b981; }
        
        .swap-input-group {
            background: rgba(0,0,0,0.3);
            padding: 20px;
            border-radius: 12px;
            margin: 15px 0;
            position: relative;
            border: 1px solid rgba(255,255,255,0.1);
        }
        
        input {
            background: rgba(255,255,255,0.08);
            border: 2px solid rgba(243, 186, 47, 0.2);
            padding: 12px;
            border-radius: 8px;
            color: white;
            font-size: 1.1em;
            width: 100%;
            margin-top: 10px;
        }
        input:focus { 
            outline: none; 
            border-color: #f3ba2f;
            box-shadow: 0 0 15px rgba(243, 186, 47, 0.3);
        }
        
        .token-search-container { position: relative; }
        .token-search {
            background: rgba(255,255,255,0.08);
            border: 2px solid rgba(243, 186, 47, 0.3);
            padding: 12px 12px 12px 40px;
            border-radius: 8px;
            color: white;
            font-size: 1.1em;
            width: 100%;
            margin-top: 10px;
        }
        .token-search::placeholder { color: rgba(255,255,255,0.4); }
        .search-icon {
            position: absolute;
            left: 12px;
            top: 22px;
            font-size: 1.2em;
        }
        
        .token-dropdown {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            max-height: 300px;
            overflow-y: auto;
            background: rgba(15, 12, 41, 0.98);
            backdrop-filter: blur(10px);
            border: 2px solid rgba(243, 186, 47, 0.3);
            border-radius: 8px;
            margin-top: 5px;
            z-index: 1000;
            display: none;
            box-shadow: 0 10px 40px rgba(0,0,0,0.5);
        }
        .token-dropdown.show { display: block; }
        .token-option {
            padding: 12px;
            cursor: pointer;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            transition: all 0.2s;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .token-option:hover { background: rgba(243, 186, 47, 0.15); }
        .token-option:last-child { border-bottom: none; }
        .token-symbol { font-weight: bold; color: #f3ba2f; }
        .token-name { font-size: 0.9em; color: #cbd5e1; margin-left: 10px; }
        .token-rank { font-size: 0.8em; color: #64748b; }
        
        .selected-token {
            background: rgba(243, 186, 47, 0.1);
            border: 2px solid rgba(243, 186, 47, 0.4);
            padding: 12px;
            border-radius: 8px;
            margin-top: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        .selected-token:hover { 
            background: rgba(243, 186, 47, 0.2);
            box-shadow: 0 4px 15px rgba(243, 186, 47, 0.3);
        }
        
        .quote-box {
            background: rgba(16, 185, 129, 0.1);
            border: 2px solid #10b981;
            padding: 15px;
            border-radius: 10px;
            margin: 15px 0;
            backdrop-filter: blur(10px);
        }
        .quote-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
        }
        
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid #f3ba2f;
            border-top-color: transparent;
            border-radius: 50%;
            animation: spin 0.6s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
        
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: rgba(0,0,0,0.3); }
        ::-webkit-scrollbar-thumb { background: rgba(243, 186, 47, 0.5); border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: rgba(243, 186, 47, 0.8); }
        
        .portfolio-tokens {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }
        
        .token-card {
            background: rgba(0,0,0,0.3);
            padding: 15px;
            border-radius: 10px;
            border: 1px solid rgba(255,255,255,0.1);
            transition: all 0.3s;
        }
        .token-card:hover {
            transform: translateY(-3px);
            border-color: rgba(243, 186, 47, 0.5);
            box-shadow: 0 5px 20px rgba(0,0,0,0.3);
        }
        .token-card-symbol { font-weight: bold; color: #f3ba2f; font-size: 1.2em; }
        .token-card-balance { color: #fff; margin: 5px 0; }
        .token-card-value { color: #10b981; font-size: 0.9em; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>💼 Portfolio BNB - Dashboard Pro</h1>
            
            <div id="status" class="status disconnected">
                <h2>🔌 Wallet non connecté</h2>
            </div>
            
            <div style="text-align: center;">
                <button id="connectBtn">🦊 Connecter MetaMask</button>
                <button id="demoBtn" style="background: linear-gradient(135deg, #8b5cf6 0%, #6d28d9 100%); color: white;">🎮 Mode Démo</button>
                <button id="disconnectBtn" class="btn-disconnect" style="display: none;">❌ Déconnecter</button>
            </div>
            
            <div id="message"></div>
        </div>
        
        <div id="dashboardSection" style="display: none;">
            <div class="dashboard">
                <div class="stat-card">
                    <div class="stat-label">💰 Valeur Totale</div>
                    <div class="stat-value" id="totalValue">$0.00</div>
                    <div class="stat-change positive" id="totalChange">+0.00%</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-label">📈 Profit/Perte 24h</div>
                    <div class="stat-value" id="dailyPL">$0.00</div>
                    <div class="stat-change positive" id="dailyChange">+0.00%</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-label">🔥 Meilleur Asset</div>
                    <div class="stat-value" id="topAsset">-</div>
                    <div class="stat-change positive" id="topAssetChange">+0.00%</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-label">💱 Swaps Totaux</div>
                    <div class="stat-value" id="totalSwaps">0</div>
                    <div style="color: #cbd5e1; font-size: 0.9em; margin-top: 10px;">Volume: <span id="swapVolume">$0</span></div>
                </div>
            </div>
            
            <div class="chart-container">
                <h2 style="color: #f3ba2f; margin-bottom: 20px;">📊 Évolution du Portfolio (30 jours)</h2>
                <canvas id="portfolioChart"></canvas>
            </div>
            
            <div class="wallet-info">
                <h3 style="color: #f3ba2f; margin-bottom: 15px;">🔑 Informations Wallet</h3>
                <div class="info-row">
                    <span class="label">Adresse:</span>
                    <span class="value" id="walletAddress">-</span>
                </div>
                <div class="info-row">
                    <span class="label">Réseau:</span>
                    <span class="value" id="network">-</span>
                </div>
                <div class="info-row">
                    <span class="label">Solde ETH:</span>
                    <span class="value" id="balance">-</span>
                </div>
            </div>
            
            <div class="chart-container">
                <h3 style="color: #f3ba2f; margin-bottom: 15px;">💎 Mes Tokens</h3>
                <div class="portfolio-tokens" id="portfolioTokens"></div>
            </div>
        </div>
        
        <div id="swapSection" class="swap-section" style="display: none;">
            <h2 style="color: #f3ba2f; margin-bottom: 20px;">🔄 Swap Crypto Multi-DEX</h2>
            
            <h3 style="margin-bottom: 15px;">Choisir l'agrégateur:</h3>
            <div class="dex-selector">
                <div class="dex-btn active" data-dex="1inch">
                    <div class="dex-name">🦄 1inch</div>
                    <div class="dex-fee">Meilleur prix</div>
                </div>
                <div class="dex-btn" data-dex="paraswap">
                    <div class="dex-name">🔷 ParaSwap</div>
                    <div class="dex-fee">Multi-path</div>
                </div>
                <div class="dex-btn" data-dex="kyberswap">
                    <div class="dex-name">⚡ KyberSwap</div>
                    <div class="dex-fee">0.1% fees</div>
                </div>
                <div class="dex-btn" data-dex="pancakeswap">
                    <div class="dex-name">🥞 PancakeSwap</div>
                    <div class="dex-fee">BSC natif</div>
                </div>
                <div class="dex-btn" data-dex="openocean">
                    <div class="dex-name">🌊 OpenOcean</div>
                    <div class="dex-fee">Liquidité max</div>
                </div>
            </div>
            
            <div class="swap-input-group">
                <label class="label">Vous envoyez:</label>
                <input type="number" id="fromAmount" placeholder="0.0" step="any">
                
                <div class="token-search-container">
                    <div class="search-icon">🔍</div>
                    <input type="text" class="token-search" id="fromTokenSearch" placeholder="Rechercher... (Bitcoin, ETH, USDT)">
                    <div class="token-dropdown" id="fromTokenDropdown"></div>
                </div>
                
                <div class="selected-token" id="fromTokenSelected" style="display: none;">
                    <div>
                        <span class="token-symbol" id="fromTokenSymbol">-</span>
                        <span class="token-name" id="fromTokenName">-</span>
                    </div>
                    <span style="color: #f3ba2f;">▼</span>
                </div>
            </div>
            
            <div style="text-align: center; font-size: 2em; margin: 10px 0;">⬇️</div>
            
            <div class="swap-input-group">
                <label class="label">Vous recevez (estimation):</label>
                <input type="number" id="toAmount" placeholder="0.0" readonly>
                
                <div class="token-search-container">
                    <div class="search-icon">🔍</div>
                    <input type="text" class="token-search" id="toTokenSearch" placeholder="Rechercher... (USDT, Ethereum)">
                    <div class="token-dropdown" id="toTokenDropdown"></div>
                </div>
                
                <div class="selected-token" id="toTokenSelected" style="display: none;">
                    <div>
                        <span class="token-symbol" id="toTokenSymbol">-</span>
                        <span class="token-name" id="toTokenName">-</span>
                    </div>
                    <span style="color: #f3ba2f;">▼</span>
                </div>
            </div>
            
            <div id="quoteBox" class="quote-box" style="display: none;">
                <div class="quote-row">
                    <span>Prix:</span>
                    <span id="quoteRate">-</span>
                </div>
                <div class="quote-row">
                    <span>Frais estimés:</span>
                    <span id="quoteFee">-</span>
                </div>
                <div class="quote-row">
                    <span>Slippage (max):</span>
                    <span>1%</span>
                </div>
                <div class="quote-row">
                    <span style="color: #4ade80;">Vous recevez (min):</span>
                    <span id="quoteMin" style="color: #4ade80; font-weight: bold;">-</span>
                </div>
            </div>
            
            <div style="text-align: center; margin-top: 20px;">
                <button id="getQuoteBtn" class="btn-swap">💹 Obtenir le Prix</button>
                <button id="executeSwapBtn" class="btn-swap" style="display: none;">🔄 Exécuter le Swap</button>
            </div>
        </div>
    </div>

    <script>
        let currentAccount = null;
        let currentChainId = null;
        let selectedDex = '1inch';
        let currentQuote = null;
        let selectedFromToken = null;
        let selectedToToken = null;
        let portfolioChart = null;
        
        const CRYPTO_LIST = [
            {rank: 1, symbol: "BTC", name: "Bitcoin", address: "0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599"},
            {rank: 2, symbol: "ETH", name: "Ethereum", address: "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"},
            {rank: 3, symbol: "USDT", name: "Tether", address: "0xdac17f958d2ee523a2206206994597c13d831ec7"},
            {rank: 4, symbol: "BNB", name: "BNB", address: "0xB8c77482e45F1F44dE1745F52C74426C631bDD52"},
            {rank: 5, symbol: "USDC", name: "USD Coin", address: "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"},
            {rank: 6, symbol: "XRP", name: "Ripple", address: "0x1d2F0da169ceB9fC7B3144628dB156f3F6c60dBE"},
            {rank: 7, symbol: "ADA", name: "Cardano", address: "0x3EE2200Efb3400fAbB9AacF31297cBdD1d435D47"},
            {rank: 8, symbol: "DOGE", name: "Dogecoin", address: "0xbA2aE424d960c26247Dd6c32edC70B295c744C43"},
            {rank: 9, symbol: "SOL", name: "Solana", address: "0x570A5D26f7765Ecb712C0924E4De545B89fD43dF"},
            {rank: 10, symbol: "MATIC", name: "Polygon", address: "0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0"},
            {rank: 11, symbol: "DOT", name: "Polkadot", address: "0x7083609fCE4d1d8Dc0C979AAb8c869Ea2C873402"},
            {rank: 12, symbol: "LTC", name: "Litecoin", address: "0x4338665CBB7B2485A8855A139b75D5e34AB0DB94"},
            {rank: 13, symbol: "SHIB", name: "Shiba Inu", address: "0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE"},
            {rank: 14, symbol: "DAI", name: "Dai", address: "0x6b175474e89094c44da98b954eedeac495271d0f"},
            {rank: 15, symbol: "AVAX", name: "Avalanche", address: "0x85f138bfEE4ef8e540890CFb48F620571d67Eda3"},
            {rank: 16, symbol: "UNI", name: "Uniswap", address: "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984"},
            {rank: 17, symbol: "LINK", name: "Chainlink", address: "0x514910771AF9Ca656af840dff83E8264EcF986CA"},
            {rank: 18, symbol: "ATOM", name: "Cosmos", address: "0x8D983cb9388EaC77af0474fA441C4815500Cb7BB"},
            {rank: 19, symbol: "XLM", name: "Stellar", address: "0x4b87642AEDF10b642BE4663Db842Ecc5A88bf5ba"},
            {rank: 20, symbol: "AAVE", name: "Aave", address: "0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9"}
        ];
        
        // Event listeners
        document.getElementById('connectBtn').addEventListener('click', connectMetaMask);
        document.getElementById('demoBtn').addEventListener('click', activateDemoMode);
        document.getElementById('disconnectBtn').addEventListener('click', disconnect);
        document.getElementById('getQuoteBtn').addEventListener('click', getQuote);
        document.getElementById('executeSwapBtn').addEventListener('click', executeSwap);
        document.getElementById('fromAmount').addEventListener('input', resetQuote);
        
        document.getElementById('fromTokenSearch').addEventListener('input', (e) => filterTokens(e, 'from'));
        document.getElementById('toTokenSearch').addEventListener('input', (e) => filterTokens(e, 'to'));
        document.getElementById('fromTokenSearch').addEventListener('focus', (e) => showDropdown('from'));
        document.getElementById('toTokenSearch').addEventListener('focus', (e) => showDropdown('to'));
        document.getElementById('fromTokenSelected').addEventListener('click', () => {
            document.getElementById('fromTokenSelected').style.display = 'none';
            document.getElementById('fromTokenSearch').value = '';
            showDropdown('from');
        });
        document.getElementById('toTokenSelected').addEventListener('click', () => {
            document.getElementById('toTokenSelected').style.display = 'none';
            document.getElementById('toTokenSearch').value = '';
            showDropdown('to');
        });
        
        document.addEventListener('click', (e) => {
            if (!e.target.closest('.token-search-container')) {
                document.getElementById('fromTokenDropdown').classList.remove('show');
                document.getElementById('toTokenDropdown').classList.remove('show');
            }
        });
        
        document.querySelectorAll('.dex-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                document.querySelectorAll('.dex-btn').forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                selectedDex = this.dataset.dex;
                resetQuote();
            });
        });
        
        window.addEventListener('load', function() {
            if (typeof window.ethereum !== 'undefined') {
                window.ethereum.on('accountsChanged', handleAccountsChanged);
                window.ethereum.on('chainChanged', () => window.location.reload());
            }
        });

        function filterTokens(event, type) {
            const query = event.target.value.toLowerCase();
            const dropdown = document.getElementById(type + 'TokenDropdown');
            
            const filtered = CRYPTO_LIST.filter(token => 
                token.symbol.toLowerCase().includes(query) || 
                token.name.toLowerCase().includes(query)
            );
            
            dropdown.innerHTML = filtered.slice(0, 50).map(token => `
                <div class="token-option" onclick="selectToken('${type}', ${JSON.stringify(token).replace(/"/g, '&quot;')})">
                    <div>
                        <span class="token-symbol">${token.symbol}</span>
                        <span class="token-name">${token.name}</span>
                    </div>
                    <span class="token-rank">#${token.rank}</span>
                </div>
            `).join('');
            
            showDropdown(type);
        }
        
        function showDropdown(type) {
            const dropdown = document.getElementById(type + 'TokenDropdown');
            if (dropdown.innerHTML === '') {
                dropdown.innerHTML = CRYPTO_LIST.slice(0, 20).map(token => `
                    <div class="token-option" onclick="selectToken('${type}', ${JSON.stringify(token).replace(/"/g, '&quot;')})">
                        <div>
                            <span class="token-symbol">${token.symbol}</span>
                            <span class="token-name">${token.name}</span>
                        </div>
                        <span class="token-rank">#${token.rank}</span>
                    </div>
                `).join('');
            }
            dropdown.classList.add('show');
        }
        
        function selectToken(type, token) {
            const tokenObj = typeof token === 'string' ? JSON.parse(token) : token;
            
            if (type === 'from') {
                selectedFromToken = tokenObj;
                document.getElementById('fromTokenSymbol').textContent = tokenObj.symbol;
                document.getElementById('fromTokenName').textContent = tokenObj.name;
                document.getElementById('fromTokenSelected').style.display = 'flex';
                document.getElementById('fromTokenSearch').value = '';
                document.getElementById('fromTokenDropdown').classList.remove('show');
            } else {
                selectedToToken = tokenObj;
                document.getElementById('toTokenSymbol').textContent = tokenObj.symbol;
                document.getElementById('toTokenName').textContent = tokenObj.name;
                document.getElementById('toTokenSelected').style.display = 'flex';
                document.getElementById('toTokenSearch').value = '';
                document.getElementById('toTokenDropdown').classList.remove('show');
            }
            
            resetQuote();
        }

        async function connectMetaMask() {
            if (typeof window.ethereum === 'undefined') {
                if (confirm('MetaMask non détecté!\n\nVoulez-vous activer le MODE DÉMO?')) {
                    activateDemoMode();
                }
                return;
            }

            try {
                showMessage('🔄 Connexion à MetaMask...', 'warning');
                
                const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
                if (!accounts || accounts.length === 0) return;

                currentAccount = accounts[0];
                currentChainId = await window.ethereum.request({ method: 'eth_chainId' });
                
                const balanceWei = await window.ethereum.request({
                    method: 'eth_getBalance',
                    params: [currentAccount, 'latest']
                });
                
                const balance = parseInt(balanceWei, 16) / 1e18;
                updateUI(currentAccount, currentChainId, balance);
                showMessage('✅ Connecté!', 'success');

            } catch (error) {
                showMessage('❌ ' + error.message, 'error');
            }
        }
        
        function activateDemoMode() {
            const demoAccount = '0x' + Math.random().toString(16).substr(2, 40);
            currentAccount = demoAccount;
            currentChainId = '0x1';
            const demoBalance = 2.5 + Math.random() * 3;
            
            updateUI(demoAccount, currentChainId, demoBalance);
            initDashboard();
            showMessage('✅ Mode DÉMO activé!', 'success');
        }

        function updateUI(account, chainId, balance) {
            document.getElementById('status').className = 'status connected';
            document.getElementById('status').innerHTML = '<h2>✅ Connecté!</h2>';
            document.getElementById('connectBtn').style.display = 'none';
            document.getElementById('demoBtn').style.display = 'none';
            document.getElementById('disconnectBtn').style.display = 'inline-block';
            
            document.getElementById('walletAddress').textContent = 
                account.substring(0, 6) + '...' + account.substring(38);
            
            const networks = {
                '0x1': 'Ethereum Mainnet',
                '0x38': 'BSC Mainnet',
                '0x89': 'Polygon'
            };
            
            document.getElementById('network').textContent = networks[chainId] || 'Chain ' + parseInt(chainId, 16);
            document.getElementById('balance').textContent = balance.toFixed(6) + ' ETH';
            
            document.getElementById('dashboardSection').style.display = 'block';
            document.getElementById('swapSection').style.display = 'block';
        }
        
        function initDashboard() {
            // Données simulées pour le dashboard
            const totalValue = 15423.67;
            const dailyChange = 5.23;
            const dailyPL = 765.43;
            
            document.getElementById('totalValue').textContent = '$' + totalValue.toLocaleString('fr-FR', {minimumFractionDigits: 2});
            document.getElementById('totalChange').textContent = '+' + dailyChange.toFixed(2) + '%';
            document.getElementById('dailyPL').textContent = '+$' + dailyPL.toFixed(2);
            document.getElementById('dailyChange').textContent = '+' + dailyChange.toFixed(2) + '%';
            document.getElementById('topAsset').textContent = 'ETH';
            document.getElementById('topAssetChange').textContent = '+8.45%';
            document.getElementById('totalSwaps').textContent = '12';
            document.getElementById('swapVolume').textContent = '$5,234';
            
            // Graphique d'évolution
            createPortfolioChart();
            
            // Afficher les tokens du portfolio
            displayPortfolioTokens();
        }
        
        function createPortfolioChart() {
            const ctx = document.getElementById('portfolioChart').getContext('2d');
            
            // Générer des données pour 30 jours
            const labels = [];
            const data = [];
            let value = 12000;
            
            for (let i = 30; i >= 0; i--) {
                const date = new Date();
                date.setDate(date.getDate() - i);
                labels.push(date.toLocaleDateString('fr-FR', { month: 'short', day: 'numeric' }));
                value += (Math.random() - 0.45) * 500;
                data.push(value);
            }
            
            if (portfolioChart) {
                portfolioChart.destroy();
            }
            
            portfolioChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Valeur Portfolio',
                        data: data,
                        borderColor: '#f3ba2f',
                        backgroundColor: 'rgba(243, 186, 47, 0.1)',
                        tension: 0.4,
                        fill: true,
                        pointRadius: 0,
                        pointHoverRadius: 6,
                        borderWidth: 3
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            backgroundColor: 'rgba(0,0,0,0.8)',
                            titleColor: '#f3ba2f',
                            bodyColor: '#fff',
                            padding: 12,
                            displayColors: false,
                            callbacks: {
                                label: function(context) {
                                    return '$' + context.parsed.y.toLocaleString('fr-FR', {minimumFractionDigits: 2});
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: false,
                            grid: { color: 'rgba(255,255,255,0.1)' },
                            ticks: { 
                                color: '#cbd5e1',
                                callback: function(value) {
                                    return '$' + (value/1000).toFixed(1) + 'k';
                                }
                            }
                        },
                        x: {
                            grid: { color: 'rgba(255,255,255,0.05)' },
                            ticks: { color: '#cbd5e1', maxRotation: 0 }
                        }
                    }
                }
            });
        }
        
        function displayPortfolioTokens() {
            const tokens = [
                { symbol: 'ETH', balance: '2.5', value: '$6,250', change: '+8.45%', positive: true },
                { symbol: 'BTC', balance: '0.15', value: '$6,750', change: '+3.21%', positive: true },
                { symbol: 'USDT', balance: '1,500', value: '$1,500', change: '+0.01%', positive: true },
                { symbol: 'BNB', balance: '5.2', value: '$1,560', change: '-2.15%', positive: false },
                { symbol: 'SOL', balance: '12', value: '$1,200', change: '+12.50%', positive: true },
                { symbol: 'MATIC', balance: '1,250', value: '$1,000', change: '+5.67%', positive: true }
            ];
            
            const html = tokens.map(t => `
                <div class="token-card">
                    <div class="token-card-symbol">${t.symbol}</div>
                    <div class="token-card-balance">${t.balance}</div>
                    <div class="token-card-value">${t.value}</div>
                    <div style="color: ${t.positive ? '#10b981' : '#ef4444'}; margin-top: 5px; font-size: 0.9em;">
                        ${t.change}
                    </div>
                </div>
            `).join('');
            
            document.getElementById('portfolioTokens').innerHTML = html;
        }

        function disconnect() {
            currentAccount = null;
            selectedFromToken = null;
            selectedToToken = null;
            document.getElementById('status').className = 'status disconnected';
            document.getElementById('status').innerHTML = '<h2>🔌 Non connecté</h2>';
            document.getElementById('connectBtn').style.display = 'inline-block';
            document.getElementById('demoBtn').style.display = 'inline-block';
            document.getElementById('disconnectBtn').style.display = 'none';
            document.getElementById('dashboardSection').style.display = 'none';
            document.getElementById('swapSection').style.display = 'none';
            document.getElementById('message').innerHTML = '';
            if (portfolioChart) portfolioChart.destroy();
        }

        function handleAccountsChanged(accounts) {
            if (accounts.length === 0) disconnect();
            else connectMetaMask();
        }

        function resetQuote() {
            document.getElementById('toAmount').value = '';
            document.getElementById('quoteBox').style.display = 'none';
            document.getElementById('executeSwapBtn').style.display = 'none';
            currentQuote = null;
        }

        async function getQuote() {
            if (!selectedFromToken || !selectedToToken) {
                showMessage('⚠️ Sélectionnez les deux tokens', 'warning');
                return;
            }
            
            const amount = parseFloat(document.getElementById('fromAmount').value);
            
            if (!amount || amount <= 0) {
                showMessage('⚠️ Entrez un montant valide', 'warning');
                return;
            }
            
            if (selectedFromToken.symbol === selectedToToken.symbol) {
                showMessage('⚠️ Choisissez deux tokens différents', 'warning');
                return;
            }
            
            const btn = document.getElementById('getQuoteBtn');
            btn.innerHTML = '<span class="loading"></span> Recherche...';
            btn.disabled = true;
            
            try {
                showMessage(`🔍 Recherche via ${selectedDex}...`, 'warning');
                
                await new Promise(resolve => setTimeout(resolve, 1500));
                
                const quote = await simulateQuote(selectedFromToken, selectedToToken, amount);
                
                if (quote) {
                    displayQuote(quote);
                    currentQuote = quote;
                    showMessage('✅ Prix obtenu!', 'success');
                }
                
            } catch (error) {
                showMessage('❌ Erreur: ' + error.message, 'error');
            } finally {
                btn.innerHTML = '💹 Obtenir le Prix';
                btn.disabled = false;
            }
        }

        async function simulateQuote(fromToken, toToken, amount) {
            const basePrices = {
                'BTC': 45000, 'ETH': 2500, 'BNB': 300, 'USDT': 1, 'USDC': 1, 'DAI': 1,
                'SOL': 100, 'ADA': 0.5, 'DOT': 7, 'MATIC': 0.8, 'LINK': 15,
                'UNI': 6, 'AVAX': 35, 'ATOM': 10, 'LTC': 70, 'XRP': 0.6, 'AAVE': 80
            };
            
            const fromPrice = basePrices[fromToken.symbol] || 1;
            const toPrice = basePrices[toToken.symbol] || 1;
            
            const rate = fromPrice / toPrice;
            const toAmount = amount * rate * 0.997;
            
            return {
                toAmount: toAmount,
                rate: rate,
                estimatedGas: 200000
            };
        }

        function displayQuote(quote) {
            const fromAmount = parseFloat(document.getElementById('fromAmount').value);
            
            document.getElementById('toAmount').value = quote.toAmount.toFixed(6);
            document.getElementById('quoteRate').textContent = 
                `1 ${selectedFromToken.symbol} = ${quote.rate.toFixed(6)} ${selectedToToken.symbol}`;
            document.getElementById('quoteFee').textContent = '~$5-10 (gas)';
            document.getElementById('quoteMin').textContent = 
                `${(quote.toAmount * 0.99).toFixed(6)} ${selectedToToken.symbol}`;
            
            document.getElementById('quoteBox').style.display = 'block';
            document.getElementById('executeSwapBtn').style.display = 'inline-block';
        }

        async function executeSwap() {
            if (!currentQuote) {
                showMessage('⚠️ Obtenez d\'abord un prix', 'warning');
                return;
            }
            
            const amount = document.getElementById('fromAmount').value;
            
            if (!confirm(`Confirmer le swap?\n\n${amount} ${selectedFromToken.symbol} → ${currentQuote.toAmount.toFixed(6)} ${selectedToToken.symbol}\n\nvia ${selectedDex}`)) {
                return;
            }
            
            showMessage(`🔄 Préparation du swap via ${selectedDex}...`, 'warning');
            
            setTimeout(() => {
                showMessage('ℹ️ Fonctionnalité en développement', 'warning');
            }, 1500);
        }

        function showMessage(text, type) {
            const msg = document.getElementById('message');
            msg.className = 'message ' + type;
            msg.textContent = text;
            setTimeout(() => msg.innerHTML = '', 6000);
        }
    </script>
</body>
</html>
