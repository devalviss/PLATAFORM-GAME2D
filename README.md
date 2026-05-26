# 🍄 Projeto: Jogo de Plataforma 2D (Estilo Mario)

Animações fluidas, pulos precisos e um mundo feito em Pixel Art. Este é um projeto de jogo de plataforma 2D desenvolvido na **Godot Engine 4**, baseado nos conceitos clássicos de movimentação e física dos jogos do Mario. 

O projeto foi construído seguindo as excelentes aulas de desenvolvimento de jogos do canal **Rafael Forbeck | Game Dev**.

---

## 🎨 Recursos Visuais & Créditos

O projeto utiliza uma combinação de assets incríveis da comunidade técnica e artística de pixel art, adaptados para o pipeline 2D da Godot:

| Recurso | Tipo | Autor/Origem | Link |
| :--- | :--- | :--- | :--- |
| **GrafxKid Pack 6** | Personagens & Inimigos | GrafxKid (Itch.io) | [Acessar Asset](https://grafxkid.itch.io/sprite-pack-6) |
| **Seasonal Tilesets** | Cenários, Moedas & Blocos | Kenney / GrafxKid | [Acessar Itch.io](https://grafxkid.itch.io/seasonal-tilesets) |
| **Trilha & Efeitos Sonoros** | Áudio Chiptune 8-bit | OpenGameArt | [Acessar Site](https://opengameart.org/) |

> ⚠️ **Nota de Configuração de Resolução:** O jogo foi estruturado nativamente na resolução clássica **288 × 208 pixels** (fator de forma Neo Geo) utilizando o modo `viewport` da Godot com técnica de *Pixel Snap* ativa. Isso garante um visual extremamente limpo ("crocante") mesmo ao expandir a janela para telas modernas em 16:9 (1080p).

---

## 🛠️ Tecnologias Utilizadas

*   **Engine:** Godot Engine 4.x
*   **Linguagem de Programação:** GDScript
*   **Estilo Visual:** Pixel Art (2D) com Filtro *Nearest* nativo

---

## 🧠 Aprendizado e Funcionalidades Implementadas

Acompanhando o tutorial do **Rafael Forbeck**, as seguintes mecânicas fundamentais de um autêntico jogo de plataforma foram desenvolvidas:

*   **Física de Movimentação Precisa:** Implementação de aceleração, atrito e desaceleração gradual para simular a sensação de "inércia" ao correr.
*   **Controle de Pulo Variável:** Se o jogador apenas tocar no botão, o pulo é curto; se segurar, o pulo é mais alto (essencial para o estilo Mario).
*   **Coyote Time & Jump Buffer:** Sistemas invisíveis que perdoam o jogador se ele pular alguns milissegundos após cair de uma plataforma, ou se apertar o botão de pulo um pouco antes de tocar o chão.
*   **Tilemaps e Colisões:** Uso das ferramentas de TileMap da Godot 4 para pintura rápida de cenários com colisões perfeitas na grade de pixels.
*   **Máquina de Estados de Animação (AnimationTree):** Transições perfeitas entre os estados de *Idle* (parado), *Run* (correndo), *Jump* (subindo) e *Fall* (caindo).

---

## 🚀 Como Executar o Projeto

Se você deseja abrir o projeto no seu computador para estudar o código ou jogar:

1. Baixe e instale a **Godot Engine 4** (versão estável mais recente).\
2. Faça o clone deste repositório:
```bash
   git clone https://github.com/devalviss/PLATAFORM-GAME2D.git
```

3.Abra a Godot Engine, clique em Importar (Import) e selecione o arquivo project.godot na pasta raiz do projeto clonado.\
4.Clique no botão de Play (ou aperte F5) no canto superior direito para rodar o jogo! \

## 🎮 Controles Padrão
Mover para Esquerda: A ou Seta Esquerda \
Mover para Direita: D ou Seta Direita \
Pular: W, Espaço ou Seta para Cima
