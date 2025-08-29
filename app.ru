from flask import Flask, render_template

app = Flask(__name__, template_folder=".")


@app.route("/")
def index():
    """Render the main simulator page."""
    return render_template("index.html")


if __name__ == "__main__":
    app.run(debug=True)


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Immigration ROI Simulator 5.0</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
    <style>
        :root {
            --primary: #2563EB;
            --accent: #10B981;
            --danger: #EF4444;
            --warning: #F59E0B;
            --dark: #0F172A;
            --muted: #64748B;
            --success: #059669;
            --purple: #8B5CF6;
            --radius: 16px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: var(--dark);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: var(--dark);
            color: white;
            padding: 20px;
            border-radius: var(--radius);
            margin-bottom: 30px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .title {
            font-size: 28px;
            font-weight: 800;
            background: linear-gradient(135deg, #10B981, #2563EB);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .nav-links {
            display: flex;
            gap: 20px;
        }

        .nav-links a {
            color: #CBD5E1;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .nav-links a:hover {
            color: var(--accent);
        }

        .hero {
            text-align: center;
            color: white;
            margin-bottom: 40px;
            padding: 40px 20px;
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: var(--radius);
            border: 1px solid rgba(255,255,255,0.2);
        }

        .hero h1 {
            font-size: 3.5rem;
            margin-bottom: 16px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .hero p {
            font-size: 1.3rem;
            margin-bottom: 30px;
            opacity: 0.95;
        }

        .hero-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }

        .hero-stat {
            background: rgba(255,255,255,0.15);
            padding: 20px;
            border-radius: 12px;
            backdrop-filter: blur(5px);
        }

        .hero-stat .number {
            font-size: 2rem;
            font-weight: bold;
            color: var(--accent);
        }

        .main-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 40px;
        }

        .card {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            border: 1px solid rgba(255,255,255,0.3);
            position: relative;
            overflow: hidden;
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--accent));
        }

        .profile-selector {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }

        .profile-card {
            padding: 20px;
            border: 2px solid #E5E7EB;
            border-radius: 16px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            background: linear-gradient(135deg, #FFFFFF, #F9FAFB);
        }

        .profile-card:hover {
            border-color: var(--primary);
            transform: translateY(-4px);
            box-shadow: 0 15px 30px rgba(37, 99, 235, 0.2);
        }

        .profile-card.selected {
            border-color: var(--primary);
            background: linear-gradient(135deg, #EBF4FF, #DBEAFE);
            box-shadow: 0 8px 25px rgba(37, 99, 235, 0.3);
        }

        .profile-card .icon {
            font-size: 2.5rem;
            margin-bottom: 12px;
        }

        .profile-card .name {
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 8px;
            color: var(--dark);
        }

        .profile-card .revenue {
            font-size: 12px;
            color: var(--muted);
        }

        .form-section {
            margin-bottom: 30px;
        }

        .form-section h3 {
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark);
            font-size: 14px;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #E5E7EB;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: white;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .currency-input {
            position: relative;
        }

        .currency-input::before {
            content: '€';
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--muted);
            font-weight: 600;
            z-index: 1;
        }

        .currency-input input {
            padding-left: 35px;
        }

        .slider-container {
            margin: 20px 0;
        }

        .slider {
            width: 100%;
            height: 8px;
            background: #E5E7EB;
            border-radius: 4px;
            outline: none;
            appearance: none;
        }

        .slider::-webkit-slider-thumb {
            appearance: none;
            width: 24px;
            height: 24px;
            background: var(--primary);
            border-radius: 50%;
            cursor: pointer;
            box-shadow: 0 4px 8px rgba(37, 99, 235, 0.3);
        }

        .slider::-moz-range-thumb {
            width: 24px;
            height: 24px;
            background: var(--primary);
            border-radius: 50%;
            cursor: pointer;
            border: none;
            box-shadow: 0 4px 8px rgba(37, 99, 235, 0.3);
        }

        .slider-value {
            display: flex;
            justify-content: space-between;
            margin-top: 8px;
            font-size: 14px;
            color: var(--muted);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: white;
            border: none;
            padding: 18px 36px;
            border-radius: 50px;
            font-size: 18px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            width: 100%;
            box-shadow: 0 10px 25px rgba(37, 99, 235, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(37, 99, 235, 0.4);
        }

        .btn-primary:active {
            transform: translateY(-1px);
        }

        .results-section {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.5s ease;
        }

        .results-section.show {
            opacity: 1;
            transform: translateY(0);
        }

        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }

        .kpi-card {
            background: white;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border-left: 4px solid var(--muted);
            position: relative;
            overflow: hidden;
        }

        .kpi-card.exceptional {
            border-left-color: var(--success);
            background: linear-gradient(135deg, rgba(16,185,129,0.03), white);
        }

        .kpi-card.good {
            border-left-color: var(--warning);
            background: linear-gradient(135deg, rgba(245,158,11,0.03), white);
        }

        .kpi-card.moderate {
            border-left-color: var(--muted);
        }

        .kpi-card .label {
            font-size: 14px;
            color: var(--muted);
            font-weight: 500;
            margin-bottom: 8px;
        }

        .kpi-card .value {
            font-size: 2rem;
            font-weight: 800;
            color: var(--dark);
            margin-bottom: 8px;
        }

        .kpi-card.exceptional .value {
            color: var(--success);
        }

        .kpi-card.good .value {
            color: var(--warning);
        }

        .kpi-card .note {
            font-size: 12px;
            color: var(--muted);
        }

        .alert {
            padding: 20px;
            border-radius: var(--radius);
            margin: 20px 0;
            font-weight: 600;
            text-align: center;
            border: 2px solid currentColor;
        }

        .alert.success {
            color: var(--success);
            background: rgba(16,185,129,0.05);
        }

        .alert.warning {
            color: var(--warning);
            background: rgba(245,158,11,0.05);
        }

        .alert.moderate {
            color: var(--muted);
            background: rgba(107,114,128,0.05);
        }

        .chart-container {
            background: white;
            border-radius: var(--radius);
            padding: 20px;
            margin: 20px 0;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        .insights-section {
            margin: 30px 0;
        }

        .insight-card {
            background: linear-gradient(135deg, rgba(37,99,235,0.03), rgba(16,185,129,0.03));
            border: 1px solid rgba(37,99,235,0.1);
            border-radius: var(--radius);
            padding: 24px;
            margin: 16px 0;
            position: relative;
        }

        .insight-card::before {
            content: '💡';
            position: absolute;
            top: -12px;
            left: 24px;
            background: white;
            padding: 0 8px;
            font-size: 20px;
        }

        .insight-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }

        .insight-title {
            font-weight: 700;
            color: var(--dark);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .match-score {
            background: var(--success);
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .share-section {
            background: linear-gradient(135deg, var(--purple), #6366F1);
            color: white;
            padding: 30px;
            border-radius: var(--radius);
            margin: 30px 0;
            text-align: center;
        }

        .share-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin: 20px 0;
        }

        .share-btn {
            padding: 12px 20px;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            color: white;
        }

        .share-btn.linkedin { background: #0077B5; }
        .share-btn.twitter { background: #1DA1F2; }
        .share-btn.whatsapp { background: #25D366; }

        .share-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
        }

        .lead-capture {
            background: white;
            border-radius: var(--radius);
            padding: 30px;
            margin: 30px 0;
            box-shadow: 0 8px 32px rgba(0,0,0,0.12);
            text-align: center;
            border: 1px solid rgba(37, 99, 235, 0.1);
        }

        .value-badge {
            background: linear-gradient(135deg, var(--success), #059669);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            display: inline-block;
            font-weight: 700;
            margin: 12px 0;
        }

        .urgency-indicator {
            background: linear-gradient(135deg, var(--danger), #DC2626);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            display: inline-block;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.8; }
        }

        .email-form {
            margin: 20px 0;
        }

        .email-form input[type="email"] {
            width: 100%;
            max-width: 400px;
            padding: 14px 20px;
            border: 2px solid #E5E7EB;
            border-radius: 10px;
            font-size: 16px;
            margin-bottom: 16px;
        }

        .email-form input[type="email"]:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .checkbox-container {
            margin: 16px 0;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .footer {
            background: rgba(15, 23, 42, 0.95);
            backdrop-filter: blur(10px);
            color: white;
            padding: 40px 20px;
            border-radius: var(--radius);
            margin-top: 40px;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
        }

        .footer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }

        .footer-section h4 {
            color: var(--accent);
            margin-bottom: 16px;
            font-size: 1.1rem;
        }

        .footer-section p {
            font-size: 14px;
            color: #CBD5E1;
            line-height: 1.6;
        }

        .disclaimer {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,0.1);
            font-size: 12px;
            color: #94A3B8;
        }

        .disclaimer a {
            color: var(--accent);
            text-decoration: none;
        }

        .disclaimer a:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .main-grid {
                grid-template-columns: 1fr;
            }
            
            .hero h1 {
                font-size: 2.5rem;
            }
            
            .hero p {
                font-size: 1.1rem;
            }
            
            .profile-selector {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .kpi-grid {
                grid-template-columns: 1fr;
            }
            
            .share-buttons {
                grid-template-columns: 1fr;
            }
            
            .header {
                flex-direction: column;
                text-align: center;
                gap: 20px;
            }
            
            .nav-links {
                margin-top: 16px;
            }
        }

        .loading {
            opacity: 0.6;
            pointer-events: none;
        }

        .fade-in {
            animation: fadeIn 0.6s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .tooltip {
            position: relative;
            cursor: help;
        }

        .tooltip::after {
            content: attr(data-tooltip);
            position: absolute;
            bottom: 100%;
            left: 50%;
            transform: translateX(-50%);
            background: var(--dark);
            color: white;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 12px;
            white-space: nowrap;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .tooltip:hover::after {
            opacity: 1;
            visibility: visible;
        }

        .progress-bar {
            width: 100%;
            height: 8px;
            background: #E5E7EB;
            border-radius: 4px;
            overflow: hidden;
            margin: 20px 0;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--primary), var(--accent));
            width: 0%;
            transition: width 1s ease-out;
        }

        .country-insights {
            margin: 20px 0;
        }

        .comparison-table {
            overflow-x: auto;
            margin: 20px 0;
        }

        .comparison-table table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: var(--radius);
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        .comparison-table th,
        .comparison-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #E5E7EB;
        }

        .comparison-table th {
            background: #F8FAFC;
            font-weight: 600;
            color: var(--dark);
        }

        .risk-indicator {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .risk-low { background: #D1FAE5; color: #065F46; }
        .risk-medium { background: #FEF3C7; color: #92400E; }
        .risk-high { background: #FEE2E2; color: #991B1B; }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <header class="header">
            <div>
                <div class="title">Immigration ROI Simulator 5.0</div>
                <div style="font-size: 14px; opacity: 0.8; margin-top: 4px;">
                    AI-Powered Financial Analysis for Smart Entrepreneurs
                </div>
            </div>
            <nav class="nav-links">
                <a href="#calculator">Calculator</a>
                <a href="#insights">Insights</a>
                <a href="#contact">Contact</a>
            </nav>
            <div style="text-align: right;">
                <div style="font-weight: 600;">Join 10,000+ Entrepreneurs</div>
                <div style="font-size: 12px; opacity: 0.7;">€50M+ in Optimized Relocations</div>
            </div>
        </header>

        <!-- Hero Section -->
        <section class="hero">
            <h1><i class="fas fa-rocket"></i> Calculate Your Immigration ROI</h1>
            <p>Make data-driven decisions about your business relocation with our advanced financial modeling</p>
            
            <div class="hero-stats">
                <div class="hero-stat">
                    <div class="number">10,000+</div>
                    <div>Successful Calculations</div>
                </div>
                <div class="hero-stat">
                    <div class="number">€50M+</div>
                    <div>Total Optimized Value</div>
                </div>
                <div class="hero-stat">
                    <div class="number">95%</div>
                    <div>Client Satisfaction</div>
                </div>
                <div class="hero-stat">
                    <div class="number">30+</div>
                    <div>Countries Analyzed</div>
                </div>
            </div>
        </section>

        <!-- Main Content Grid -->
        <div class="main-grid" id="calculator">
            <!-- Input Form -->
            <div class="card">
                <div class="form-section">
                    <h3><i class="fas fa-user-tie"></i> Your Profile</h3>
                    <div class="profile-selector" id="profileSelector">
                        <div class="profile-card" data-profile="startup">
                            <div class="icon">🚀</div>
                            <div class="name">Startup Founder</div>
                            <div class="revenue">~€15k/month</div>
                        </div>
                        <div class="profile-card" data-profile="crypto">
                            <div class="icon">₿</div>
                            <div class="name">Crypto Entrepreneur</div>
                            <div class="revenue">~€75k/month</div>
                        </div>
                        <div class="profile-card" data-profile="consulting">
                            <div class="icon">💼</div>
                            <div class="name">Consultant</div>
                            <div class="revenue">~€35k/month</div>
                        </div>
                        <div class="profile-card" data-profile="saas">
                            <div class="icon">💻</div>
                            <div class="name">SaaS Founder</div>
                            <div class="revenue">~€50k/month</div>
                        </div>
                        <div class="profile-card" data-profile="realestate">
                            <div class="icon">🏠</div>
                            <div class="name">Real Estate</div>
                            <div class="revenue">~€25k/month</div>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h3><i class="fas fa-chart-line"></i> Current Financial Situation</h3>
                    
                    <div class="form-group">
                        <label for="monthlyRevenue" class="tooltip" data-tooltip="Your current monthly business revenue">
                            Monthly Revenue <i class="fas fa-info-circle"></i>
                        </label>
                        <div class="currency-input">
                            <input type="number" id="monthlyRevenue" value="30000" min="1000" step="1000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="marginSlider">EBITDA Margin (%)</label>
                        <div class="slider-container">
                            <input type="range" id="marginSlider" class="slider" value="25" min="1" max="70" step="1">
                            <div class="slider-value">
                                <span>1%</span>
                                <span id="marginValue">25%</span>
                                <span>70%</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="corpTaxSlider">Current Corporate Tax (%)</label>
                        <div class="slider-container">
                            <input type="range" id="corpTaxSlider" class="slider" value="20" min="0" max="50" step="1">
                            <div class="slider-value">
                                <span>0%</span>
                                <span id="corpTaxValue">20%</span>
                                <span>50%</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="personalTaxSlider">Personal Tax Rate (%)</label>
                        <div class="slider-container">
                            <input type="range" id="personalTaxSlider" class="slider" value="10" min="0" max="50" step="1">
                            <div class="slider-value">
                                <span>0%</span>
                                <span id="personalTaxValue">10%</span>
                                <span>50%</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="livingCosts">Monthly Living Costs</label>
                        <div class="currency-input">
                            <input type="number" id="livingCosts" value="4000" min="500" step="100">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="businessCosts">Monthly Business Costs</label>
                        <div class="currency-input">
                            <input type="number" id="businessCosts" value="500" min="0" step="100">
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h3><i class="fas fa-globe"></i> Target Country</h3>
                    
                    <div class="form-group">
                        <label for="targetCountry">Destination</label>
                        <select id="targetCountry">
                            <option value="uae">UAE (Dubai)</option>
                            <option value="singapore">Singapore</option>
                            <option value="uk">United Kingdom</option>
                            <option value="estonia">Estonia</option>
                            <option value="portugal">Portugal</option>
                            <option value="netherlands">Netherlands</option>
                            <option value="usa">USA (Delaware)</option>
                            <option value="ireland">Ireland</option>
                            <option value="spain">Spain</option>
                        </select>
                    </div>

                    <div class="country-insights" id="countryInsights"></div>
                </div>

                <div class="form-section">
                    <h3><i class="fas fa-rocket"></i> Growth Projections</h3>
                    
                    <div class="form-group">
                        <label for="revenueMultiplier">Expected Revenue Growth (×)</label>
                        <div class="slider-container">
                            <input type="range" id="revenueMultiplier" class="slider" value="3.0" min="0
