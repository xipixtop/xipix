const express = require('express');
const fs = require('fs');
const path = require('path');
const app = express();

app.use(express.json());
// Torna a pasta public acessível para downloads diretos
app.use(express.static(path.join(__dirname, 'public')));

// Configuração de Senhas e suas respectivas pastas
const BANCO_SENHAS = {
    "admin789": "utilitarios",
    "senha123": "cliente_1",
    "senha456": "cliente_2",
    "senha789": "cliente_3",
    "senhaabc": "cliente_4",
    "senhaxyz": "cliente_5"
};

// Tela única do sistema (HTML dinâmico)
app.get('/', (req, res) => {
    res.send(`
    <!DOCTYPE html>
    <html lang="pt-BR">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xipix.top - Painel Computacional</title>
        <style>
            body { font-family: 'Segoe UI', Arial, sans-serif; background: #f0f2f5; margin: 0; padding: 20px; text-align: center; color: #333; }
            .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.08); }
            h1 { color: #0f172a; font-size: 28px; margin-bottom: 5px; font-weight: 800; }
            .brand-sub { color: #2563eb; font-size: 14px; font-weight: bold; letter-spacing: 1px; text-transform: uppercase; margin-bottom: 25px; }
            .login-box { background: #f8fafc; padding: 25px; border-radius: 8px; margin-bottom: 25px; border: 1px solid #e2e8f0; }
            .login-box input { padding: 12px; font-size: 16px; width: 55%; max-width: 250px; border: 1px solid #cbd5e1; border-radius: 6px; margin-right: 10px; outline: none; }
            .login-box button { padding: 12px 24px; font-size: 16px; background: #2563eb; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: bold; }
            .login-box button:hover { background: #1d4ed8; }
            .error-msg { color: #dc2626; font-size: 14px; margin-top: 12px; display: none; font-weight: 600; }
            .painel-arquivos { display: none; text-align: left; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 8px; padding: 20px; }
            .painel-titulo { font-size: 18px; color: #1e293b; margin-top: 0; margin-bottom: 15px; padding-bottom: 8px; border-bottom: 2px solid #2563eb; font-weight: 700; }
            .lista-links { display: grid; grid-template-columns: 1fr; gap: 10px; }
            .btn-download { display: flex; align-items: center; justify-content: space-between; background: #f8fafc; color: #334155; border: 1px solid #cbd5e1; padding: 14px; text-decoration: none; border-radius: 6px; font-weight: 600; font-size: 14px; transition: all 0.2s; }
            .btn-download:hover { background: #2563eb; color: white; border-color: #2563eb; }
        </style>
    </head>
    <body>
    <div class="container">
        <h1>XIPIX.TOP</h1>
        <div class="brand-sub">Serviços Computacionais</div>
        
        <div class="login-box">
            <input type="password" id="tokenAcesso" placeholder="Digite seu token...">
            <button onclick="buscarArquivos()">Acessar Pasta</button>
            <div id="erro" class="error-msg">Token inválido ou pasta vazia!</div>
        </div>

        <div id="painel" class="painel-arquivos">
            <div id="titulo-pasta" class="painel-titulo">📁 Arquivos Disponíveis</div>
            <div id="lista" class="lista-links"></div>
        </div>
    </div>

    <script>
    async function buscarArquivos() {
        const token = document.getElementById("tokenAcesso").value.trim();
        const erro = document.getElementById("erro");
        const painel = document.getElementById("painel");
        const lista = document.getElementById("lista");

        erro.style.display = "none";
        painel.style.display = "none";
        lista.innerHTML = "";

        if (!token) return;

        try {
            const response = await fetch('/listar-arquivos', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ token })
            });

            const dados = await response.json();

            if (dados.sucesso && dados.arquivos.length > 0) {
                document.getElementById("titulo-pasta").innerText = "📁 Pasta: " + dados.pasta.toUpperCase();
                
                dados.arquivos.forEach(arquivo => {
                    const urlDownload = "/" + dados.pasta + "/" + arquivo;
                    lista.innerHTML += \`
                        <a href="\${urlDownload}" class="btn-download" download="\${arquivo}">
                            <span>📄 \${arquivo}</span>
                            <strong>📥 Baixar</strong>
                        </a>
                    \`;
                });
                painel.style.display = "block";
            } else {
                erro.style.display = "block";
            }
        } catch (e) {
            erro.style.display = "block";
        }
    }

    document.getElementById("tokenAcesso").addEventListener("keypress", function(e) {
        if (e.key === "Enter") buscarArquivos();
    });
    </script>
    </body>
    </html>
    `);
});

// Endpoint seguro que lê a pasta no servidor de acordo com a senha
app.post('/listar-arquivos', (req, requireRes) => {
    const { token } = req.body;
    const pastaAlvo = BANCO_SENHAS[token];

    if (!pastaAlvo) {
        return requireRes.status(400).json({ sucesso: false, erro: "Token inválido" });
    }

    const caminhoPasta = path.join(__dirname, 'public', pastaAlvo);

    if (!fs.existsSync(caminhoPasta)) {
        return requireRes.json({ sucesso: true, pasta: pastaAlvo, arquivos: [] });
    }

    // Lê todos os arquivos da pasta física em tempo real
    fs.readdir(caminhoPasta, (err, arquivos) => {
        if (err) {
            return requireRes.status(500).json({ sucesso: false });
        }
        // Remove arquivos ocultos do sistema (como arquivos temporários)
        const arquivosFiltrados = arquivos.filter(arq => !arq.startsWith('.'));
        requireRes.json({ sucesso: true, pasta: pastaAlvo, arquivos: arquivosFiltrados });
    });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log('Painel Xipix rodando na porta ' + PORT));
