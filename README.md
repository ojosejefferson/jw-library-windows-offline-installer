# 📖 JW Library - Instalador Offline Automático (Windows 10 / 11)
### Solução Definitiva para Windows Modificado, Lite e Sem Microsoft Store
*(Compatível com SnyX OS, Ghost Spectre, Tiny10, ReviOS, Windows 10 LTSC e PCs antigos)*

[![GitHub Release](https://img.shields.io/github/v/release/ojosejefferson/jw-library-windows-offline-installer?style=for-the-badge&color=blue)](https://github.com/ojosejefferson/jw-library-windows-offline-installer/releases)
[![Platform](https://img.shields.io/badge/Plataforma-Windows%2010%20%7C%2011%20(64--bit)-0078D6?style=for-the-badge&logo=windows)](https://github.com/ojosejefferson/jw-library-windows-offline-installer)
[![License](https://img.shields.io/badge/Status-100%25%20Funcional-success?style=for-the-badge)](https://github.com/ojosejefferson/jw-library-windows-offline-installer)

---

## 🎯 Por que este projeto foi criado?

Ao utilizar edições otimizadas do Windows (como **SnyX OS**, **Ghost Spectre**, **Tiny10** ou builds sem telemetria para computadores antigos/fracos), é muito comum não conseguir instalar ou abrir o **JW Library**.

### Principais problemas que impedem a instalação padrão:
1. **Ausência da Microsoft Store:** O instalador gráfico padrão de pacotes `.msixbundle` não existe no sistema.
2. **Serviços Bloqueados no Registro (`AppXSvc` / `ClipSVC`):** Criadores de ISOs Lite desativam o *Serviço de Implantação AppX* (`Start = 4`), gerando o erro:  
   `"O serviço não pode ser iniciado porque está desativado ou não tem dispositivos ativados associados."`
3. **Erro de Certificado Digital (`0x800B0109`):** O Windows rejeita o aplicativo sideloaded porque o certificado oficial da JW não está na raiz confiável do computador.
4. **Scripts Oficiais Travam:** O script `.ps1` fornecido no site oficial tenta contatar servidores de telemetria da Microsoft (que estão bloqueados em sistemas Lite) e entra em espera infinita.
5. **Erro de "Microsoft Edge WebView2":** Ao conseguir instalar, o aplicativo fecha ou avisa que o *WebView2 Runtime* não foi detectado (já que o Edge também é removido em sistemas Lite).

---

## 🚀 Como Esta Solução Resolve Tudo (1-Clique)

Este projeto empacota os **arquivos oficiais e originais da JW.ORG** em um instalador inteligente (`.exe` ou `.bat`) que:

* ✅ **Reativa os Serviços do Windows:** Destrava no Registro do Windows o `AppXSvc`, `ClipSVC`, `InstallService` e `StateRepository`.
* ✅ **Habilita o Sideloading:** Configura as políticas `AllowAllTrustedApps` para permitir aplicativos fora da loja.
* ✅ **Instala o Certificado Oficial:** Importa o certificado da JW silenciosamente para `TrustedPeople` e `Root` via `certutil`.
* ✅ **Instala Todas as Dependências x64:** `Microsoft.VCLibs`, `Microsoft.NET.Native.Framework`, `Microsoft.NET.Native.Runtime` e `Microsoft.UI.Xaml 2.8`.
* ✅ **Instala o JW Library:** Registra o aplicativo completo e cria o atalho no Menu Iniciar.
* ✅ **Suporte ao WebView2 Runtime:** Inclui o instalador do motor de renderização exigido pelo JW Library para exibir textos e publicações.

---

## 📥 Como Baixar e Instalar

### Opção 1: Instalador Automático Executável (.exe)
1. Acesse a aba **[Releases](https://github.com/ojosejefferson/jw-library-windows-offline-installer/releases)** deste repositório.
2. Baixe o arquivo:
   * **`Instalador_JW_Library_Offline.exe`**
3. Dê dois cliques no arquivo baixado e confirme a permissão de Administrador.
4. Aguarde a mensagem verde: **"JW LIBRARY INSTALADO COM SUCESSO!"**.

### Opção 2: Se o app pedir o "Microsoft Edge WebView2":
O JW Library moderno utiliza o motor do WebView2 para carregar o texto da Bíblia e publicações. Se o seu Windows Lite não possuir esse componente:
1. Baixe o **`MicrosoftEdgeWebview2Setup.exe`** (ou a versão offline `MicrosoftEdgeWebView2RuntimeInstallerX64.exe`) disponível na aba [Releases](https://github.com/ojosejefferson/jw-library-windows-offline-installer/releases).
2. Instale normalmente (leva menos de 1 minuto).
3. Abra o JW Library pelo Menu Iniciar!

---

## 🛠️ Scripts Inclusos no Repositório

| Arquivo | Função |
| :--- | :--- |
| **`CLIQUE_AQUI_PARA_INSTALAR.bat`** | Script de automação total: desbloqueia o Registro, instala certificados, dependências e o JW Library. |
| **`00_ATIVAR_SERVICOS_WINDOWS.bat`** | Utilitário rápido para reativar serviços `AppXSvc` e `ClipSVC` caso você queira destravar a instalação manual. |

---

## ⚖️ Aviso Legal / Disclaimer

* Este repositório tem finalidade exclusivamente educacional, técnica e de auxílio comunitário para permitir a execução do aplicativo em hardwares antigos ou sistemas otimizados.
* Todos os direitos intelectuais, marcas, código do aplicativo e certificados pertencem à **Watch Tower Bible and Tract Society of Pennsylvania**.
* Nenhum arquivo de mídia ou binário do aplicativo foi alterado ou modificado; todos os pacotes foram obtidos diretamente dos canais e servidores públicos oficiais da [jw.org](https://www.jw.org).
