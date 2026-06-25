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
   `OptiPatcher.asi`, `D3D12_Optiscaler\`, `Licenses\`, `FSR4_INT8_4.0.2c\`).
   - A pasta **`DLSS 310.6\` é opcional**. Deixe-a **fora** do `payload.zip` para encolher bastante
     o exe e **não embutir DLLs proprietários da NVIDIA** — a opção "Atualizar DLSS" se desativa
     sozinha no app. Isso também reduz o falso-positivo de antivírus (blob grande = cara de "dropper").
2. Rode `build.bat` (usa o `csc.exe` do .NET Framework 4 que já vem no Windows).

> Os binários do mod, o `payload.zip` e o exe **não** ficam no git (grandes/terceiros).

## Auto-update (GitHub Releases)
Ao abrir, o app procura no GitHub a **release mais nova que tenha o `Instalar_Mod.exe` anexado**
(o repo padrão `dytech0021/frame-gen-mod` é **embutido no código**, então o exe único também se
atualiza; um `update.cfg` ao lado do exe pode sobrescrever). Se a tag for **maior** que a versão
interna (`App.Version`), ele baixa e se substitui sozinho, e reabre.

### Como lançar uma atualização
1. Aumente **as duas** versões em `OptiInstaller.cs` (mesmo número): `App.Version` e os
   atributos `AssemblyFileVersion`/`AssemblyVersion` no topo do arquivo.
2. Faça commit, crie a tag e dê push: `git tag v2.6 && git push origin v2.6`.
3. O workflow de CI (veja abaixo) compila, **assina** e anexa o `Instalar_Mod.exe` na release `v2.6`.

> ⚠️ A tag da release **deve bater** com `App.Version` do exe — senão entra em loop de update.
> (Para compilar à mão sem CI, use `build.bat`, mas o exe sai **sem assinatura**.)

## Assinatura de código (SignPath — grátis p/ open-source)
A correção definitiva do falso positivo de antivírus é **assinar o exe** (Authenticode). Isto é
feito automaticamente pelo workflow `.github/workflows/build-and-sign.yml` usando a
[SignPath Foundation](https://about.signpath.io/product/open-source), gratuita para projetos
open-source. Configuração (uma vez só):

1. **Aplique ao programa OSS** em https://about.signpath.io/product/open-source com este repo
   (precisa de uma licença OSI — já incluímos a `LICENSE` MIT). Aguarde a aprovação.
2. No SignPath, crie um **Project** (`frame-gen-mod`), uma **Artifact configuration** (executável
   `.exe`) e uma **Signing policy** (ex.: `release-signing`). Configure o **Trusted Build System**
   apontando para este repositório e o workflow `build-and-sign.yml` (instale o **SignPath GitHub App**).
3. No GitHub, em **Settings → Secrets and variables → Actions**, adicione:
   - **Secret** `SIGNPATH_API_TOKEN` — token da API do SignPath.
   - **Secret** `PAYLOAD_URL` — link direto de download do `payload.zip` (binários do mod).
   - **Variables** `SIGNPATH_ORGANIZATION_ID`, `SIGNPATH_PROJECT_SLUG`, `SIGNPATH_SIGNING_POLICY_SLUG`.
4. Pronto: a cada tag `v*`, o CI compila, manda assinar e publica o exe assinado na release.

> Mesmo assinado, a reputação no **SmartScreen** leva alguns downloads para "esquentar".
> Enquanto isso, vale também reportar à Microsoft (veja abaixo).

## Antivírus (falso positivo)
O `Instalar_Mod.exe` **não tem vírus**, mas pode ser detectado pelo Windows Defender como
`Trojan:Win32/Wacatac.B!ml`. O sufixo **`!ml`** indica detecção por *machine-learning*
(heurística genérica), não uma assinatura de malware real. É um falso positivo comum em `.exe`
de .NET **não assinados** que baixam/atualizam arquivos.

**O que reduz o falso positivo (já aplicado / planejado):**
- ✅ Metadados de versão embutidos no exe (empresa, produto, versão) — dão "identidade" ao binário.
- ⏳ **Assinatura de código** (Authenticode) — a correção definitiva. Sem isso o aviso pode voltar.
- ⏳ **Reporte de falso positivo à Microsoft** a cada release (whitelist em ~24–72h).

**Para o usuário liberar manualmente (se confiar na fonte):**
1. Windows Defender → *Proteção contra vírus e ameaças* → *Histórico de proteção* → permitir o item; **ou**
2. *Configurações de proteção contra vírus e ameaças* → *Exclusões* → adicionar a pasta do exe.

> O payload de ~77 MB embutido (a partir da v2.5) aumenta a chance de detecção heurística
> (blob comprimido grande = cara de "dropper"). Uma alternativa é o exe baixar o payload no
> primeiro uso, em vez de embuti-lo — reduz o tamanho e o gatilho de ML, mas perde o "exe único".

## Observações
- O exe **não é assinado**; o Windows Defender/SmartScreen pode exibir aviso de editor desconhecido.
