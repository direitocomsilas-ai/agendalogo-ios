# PUBLICAR O AGENDA LOGO NA APP STORE — PASSO A PASSO

> Este guia foi escrito para quem NUNCA usou GitHub ou a App Store Connect.
> Siga na ordem, um passo por vez. Não pule nenhum.

## O que você já tem (pronto, não precisa fazer nada)

- Um app iOS nativo criado para o Agenda Logo (código nesta pasta)
- Um "robô" (GitHub Actions) que compila e envia para a Apple sozinho
- Ícone, nome e configurações já aplicados
- Conta demo para os avaliadores da Apple: `demo.agendalogo@agendez.app` / `Demo@2026`

O que VOCÊ vai fazer: subir esta pasta no GitHub, colar 4 chaves da Apple, e apertar um botão. O resto é automático.

---

# PARTE A — Criar o repositório no GitHub (10 min)

1. Acesse **https://github.com** e crie sua conta (ou entre).
2. No canto superior direito, clique no **+** → **New repository**.
3. Preencha:
   - **Repository name**: `agendalogo-ios`
   - **Private** ou **Public**: veja a nota abaixo
   - **NÃO** marque "Add a README"
4. Clique em **Create repository**.

**Sobre Private x Public:** o GitHub cobra "minutos de computação" para rodar o build em computador Mac. Em repositório **público** é **grátis e ilimitado**; em privado você tem ~5 builds gratuitos por mês. O código desta pasta não tem nenhum segredo (as chaves ficam escondidas pelo GitHub nos dois casos) — por isso recomendo **Public**.

# PARTE B — Subir os arquivos (10 min)

1. Na página do repositório recém-criado, clique no link **"uploading an existing file"**.
2. Abra a pasta extraída (`agendalogo-ios-github`) no seu computador.
3. **Arraste as DUAS pastas (`​.github` e `app`) e os DOIS arquivos (`LEIA-ME-PASSO-A-PASSO.md` e `.gitignore`)** para dentro da área de arrastar do navegador.
   - Importante: arraste o que está DENTRO da pasta, não a pasta inteira. A estrutura no GitHub deve ficar:
     ```
     .github/workflows/ios.yml
     app/project.yml
     app/AgendaLogo/...
     app/fastlane/Fastfile
     LEIA-ME-PASSO-A-PASSO.md
     .gitignore
     ```
4. Role para baixo e clique em **Commit changes**.

# PARTE C — Pegar as chaves na Apple (15 min)

Você vai pegar 4 informações no site da Apple. Deixe abertos: github.com (aba 1) e appstoreconnect.apple.com (aba 2).

### C1 — Team ID (ID da equipe)
1. Acesse **https://appstoreconnect.apple.com** e entre com sua conta.
2. Vá em **Acesso** (Users and Access) ou abra https://developer.apple.com/account → procure **"ID da Equipe" / "Team ID"**.
3. É um código de 10 letras/números (ex.: `AB12CD34EF`). **Copie e guarde.**

### C2 — Chave de API
1. Em **App Store Connect**: **Usuários e Acesso → Integrações → App Store Connect API** (ou "Chaves de API").
2. Clique no **+**:
   - Nome: `GitHub`
   - Acesso (Role): **App Manager** (ou Admin)
3. Clique em **Gerar**. Na lista:
   - Copie o **Issuer ID** (aparece no topo da página) → **guarde**
   - Copie o **Key ID** (ID da chave que você criou) → **guarde**
   - Clique em **Baixar API Key** — baixa um arquivo `AuthKey_XXXX.p8` — **só dá para baixar UMA VEZ, guarde bem esse arquivo**

# PARTE D — Colar as chaves no GitHub (10 min)

1. No GitHub, abra seu repositório → **Settings** (engrenagem no topo) → no menu da esquerda, **Secrets and variables → Actions**.
2. Clique em **New repository secret** e crie **UM POR UM** (nome em maiúsculas exatamente igual):

| Nome (Name) | Valor (Secret) — o que colar |
|---|---|
| `APPLE_TEAM_ID` | O Team ID da Parte C1 |
| `APPSTORE_ISSUER_ID` | O Issuer ID da Parte C2 |
| `APPSTORE_KEY_ID` | O Key ID da Parte C2 |
| `APPSTORE_P8` | Abra o arquivo `AuthKey_XXXX.p8` no **Bloco de Notas** e cole TUDO (as linhas `-----BEGIN PRIVATE KEY-----` e `-----END PRIVATE KEY-----` incluídas) |
| `MATCH_PASSWORD` | Uma senha inventada forte qualquer (ex.: `Bolo@Verde2026#Laranja`). Você nunca vai usar essa senha em lugar nenhum — é só para criptografar os certificados guardados no repositório. Anote-a por segurança. |

3. No final você deve ter 5 segredos na lista.

# PARTE E — Rodar o build (aperta 1 botão, espera ~30 min)

1. No GitHub, abra a aba **Actions** (menu do topo do repositório).
2. Se aparecer um aviso "Workflows aren't being run on this repository", clique em **"I understand my workflows, go ahead and enable them"**.
3. No menu da esquerda, clique em **"iOS - Build e TestFlight"**.
4. À direita, clique em **Run workflow** → confirme em **Run workflow** (verde).
5. **Espere de 20 a 40 minutos.** Uma linha amarela girando = rodando. Quando ficar verde ✅, o app foi enviado para a Apple.
   - Se ficar vermelho ❌: clique nele, veja qual etapa falhou e procure a mensagem na tabela "Problemas comuns" no final deste guia.
6. (Opcional) Um segundo processo gerou **capturas de tela**: no mesmo run, role até "Artifacts" e baixe `capturas-de-tela` — você vai usar na Parte F.

# PARTE F — TestFlight: testar no seu iPhone (15 min)

1. Acesse **https://appstoreconnect.apple.com** → **Meus Apps** → **Agenda Logo** (aparece depois do build).
2. Aba **TestFlight** → na seção "O que testar" (What to Test), escreva: `Teste completo do app Agenda Logo. Login demo: demo.agendalogo@agendez.app / Demo@2026` → Salvar.
3. Em "Testers" → adicione **você mesmo** (seu e-mail). Você receberá um convite — instale o app **TestFlight** na App Store no seu iPhone, aceite o convite e instale o Agenda Logo.
4. Teste: login com a conta demo, agenda, clientes, fluxo de caixa.

# PARTE G — Ficha da App Store e envio para revisão (1 h)

Acesse **App Store Connect → Meus Apps → Agenda Logo** (se não existir ainda, crie com **+** → "Novo App": iOS, nome `Agenda Logo`, idioma Português, pacote `com.agendalogo.app`).

Preencha a aba **Distribuição da App Store** (App Store):

1. **Capturas de tela do iPhone**: use as imagens do artifact `capturas-de-tela` (Parte E, item 6). Precisa da posição **6.9"** (ou 6.5"). Se não tiver, tire prints no seu iPhone com o app aberto (via TestFlight).
2. **Descrição / Subtítulo / Palavras-chave**: copie dos textos prontos em `store/apple/` do projeto do site (ficha da loja).
3. **URL de Política de Privacidade**: precisa de um link público. O texto está pronto em `store/politica-de-privacidade.md` — **me peça para publicar essa página no seu site** (fica em `/politica-de-privacidade`) e use o link.
4. **EULA (Termos de Uso)**: em "Licença (EULA)" escolha texto personalizado e cole o conteúdo de `store/apple/termos-de-uso-ios.md`.
5. **Categoria**: Principal `Estilo de vida` ou `Empresas`; Secundária `Produtividade`.
6. **Copyright**: `Silas Vieira`.
7. **Idade**: responda o questionário — nada de conteúdo restrito; resultado deve ser 4+.
8. Na versão, no campo **"Informações de login do revisor"**:
   - Usuário: `demo.agendalogo@agendez.app`
   - Senha: `Demo@2026`
   - **Notas para o revisor**: `Conta de demonstração com dados de exemplo prontos. Após o login, a agenda principal aparece com agendamentos de exemplo. Não é necessário configurar nada.`
9. Clique em **Enviar para Revisão** (Submit for Review).

A Apple costuma responder em 24–48 horas. Se recusarem, a resposta deles chega com o motivo — **me envie o texto que eu corrijo o que pedirem**.

---

## Problemas comuns (aba Actions → clique no run falho)

| Mensagem que apareceu | O que fazer |
|---|---|
| `Invalid JWT` / `401` / `invalid_client` | Alguma das 3 chaves (Issuer ID, Key ID ou .p8) foi colada errada. Confira na Parte D. |
| `Could not find AuthKey` | O segredo `APPSTORE_P8` está vazio ou sem as linhas BEGIN/END. Cole o conteúdo inteiro do arquivo. |
| `The app name is already taken` | O nome "Agenda Logo" já existe na App Store. Crie o app manualmente (Parte G) com nome `Agenda Logo - Gestão` e rode o workflow de novo — o resto funciona igual. |
| `no matching provisioning profile` | Rode o workflow novamente (segunda tentativa costuma resolver). Se persistir, me avise. |
| `build minutes exceeded` / cobrança | Seu repositório é privado e os minutos gratuitos acabaram. Torne o repositório **público** (Settings → General → Danger Zone → Change visibility) — builds ficam grátis. |
| Falha na etapa `Capturar telas` | Pode ignorar — são as capturas automáticas, opcionais. O build principal é o job "release". |

## Perguntas rápidas

**Preciso de um Mac?** Não. O GitHub roda o build num Mac na nuvem.

**Quanto custa?** GitHub: grátis (repositório público). Apple: você já pagou a anuidade. Nada mais.

**Posso atualizar o app depois?** Sim — quando o SITE mudar, o app atualiza sozinho (o app carrega o site). Só gere nova versão no GitHub (mude `MARKETING_VERSION` no arquivo `app/project.yml` de 1.0.0 para 1.0.1 e rode o workflow) quando você quiser texto novo na loja ou recursos nativos novos.

**Entrar com Google funciona?** Dentro do app, use e-mail e senha (o login Google abre no Safari por limitação do próprio Google). O login da conta demo é e-mail/senha — por isso os revisores não passam por isso.
