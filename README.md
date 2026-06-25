# Instalador de Mods — OptiScaler + Frame Generation

App com interface (.NET Framework / WinForms) que instala automaticamente, em jogos, o
**OptiScaler + dlssg-to-fsr3 + fakenvapi + OptiPatcher**, com upgrade de **DLSS 310.6** e
**FSR4** opcionais. Pensado para placas **RTX 20/30** (Frame Generation via FSR3).

## O que o app faz
- Detecta o motor do jogo: **Unreal Engine** (instala em `...\Binaries\Win64`) ou **flat/RE Engine** (instala na raiz).
- **Bloqueia** a instalação se detectar **anti-cheat** (EasyAntiCheat/BattlEye/Vanguard) — evita banimento.
- **Avisa** se o jogo não tem DLSS/FSR (onde o mod não funciona).
- Não sobrescreve DLLs nativos do jogo; faz **backup** do que troca.
- Campo de caminho com **colar** ou **Procurar**; menu do OptiScaler na tecla **=**.

## Arquivos
| Arquivo | Função |
|---|---|
| `OptiInstaller.cs` | Código do app |
| `MakeIcon.cs` | Gera o `skull.ico` |
| `skull.ico` | Ícone (caveira) |
| `Instalar_Mod.exe` | App compilado — **baixe na aba Releases** (não fica no git) |
| `update.cfg` | (opcional) sobrescreve o repo do auto-update |
| `build.bat` | Recompila (requer `payload.zip`) |

## Exe autossuficiente
A partir da **v2.5** o `Instalar_Mod.exe` é um **arquivo único**: o payload do mod (OptiScaler,
dlssg-to-fsr3, fakenvapi, OptiPatcher, DLSS 310.6 e FSR4) fica **embutido** no exe e é extraído
para `%LOCALAPPDATA%\FrameGenMod` na primeira execução. Não precisa de nenhum arquivo ao lado —
baixe o exe na aba **Releases** e rode de qualquer lugar.

## Compilar
1. Gere o `payload.zip` com os arquivos do mod na raiz (`dxgi.dll`, `OptiScaler.ini`,
   `dlssg_to_fsr3_amd_is_better.dll`, `fakenvapi.dll`/`.ini`, `amd_fidelityfx_dx12.dll`,
   `OptiPatcher.asi`, `D3D12_Optiscaler\`, `Licenses\`, `DLSS 310.6\`, `FSR4_INT8_4.0.2c\`).
2. Rode `build.bat` (usa o `csc.exe` do .NET Framework 4 que já vem no Windows).

> Os binários do mod, o `payload.zip` e o exe **não** ficam no git (grandes/terceiros).

## Auto-update (GitHub Releases)
Ao abrir, o app procura no GitHub a **release mais nova que tenha o `Instalar_Mod.exe` anexado**
(o repo padrão `dytech0021/frame-gen-mod` é **embutido no código**, então o exe único também se
atualiza; um `update.cfg` ao lado do exe pode sobrescrever). Se a tag for **maior** que a versão
interna (`App.Version`), ele baixa e se substitui sozinho, e reabre.

### Como lançar uma atualização
1. Aumente `App.Version` em `OptiInstaller.cs` e rode `build.bat`.
2. Crie uma **release** com a tag igual (ex.: `v2.6`) e anexe o novo `Instalar_Mod.exe`.

> ⚠️ A tag da release **deve bater** com `App.Version` do exe — senão entra em loop de update.

## Observações
- O exe **não é assinado**; o Windows Defender/SmartScreen pode exibir aviso de editor desconhecido.
