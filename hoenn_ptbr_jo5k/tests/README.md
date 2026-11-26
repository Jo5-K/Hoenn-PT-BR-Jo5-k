# Testes

Na pasta do mod:

```
luajit tests/options.lua
lua tests/options.lua
luajit tests/layout.lua
lua tests/layout.lua
```

O teste não fornece `mod.game`, impede o uso de módulos do motor pelo ponto de entrada e verifica nomes em português/inglês, descrições e preservação dos parâmetros de jogo.

A partir de qualquer pasta, o teste de integração aceita:

```
luajit /caminho/do/mod/tests/loader.lua /fontes/do/motor /caminho/do/mod emerald /cache/emerald
```

O último argumento é a pasta que contém `data/generated/gba/` do Emerald. O teste lê o cache, mas simula o sistema de arquivos do carregador em memória. Apenas este mod é apresentado ao carregador; FireRed não está instalado nessa simulação. Use fontes de um `game.love` extraído do APK para testar o mesmo carregador do Android.

É possível substituir `emerald` por `firered` para verificar que o manifesto exclui FRLG. Nos testes com `ruby`/`sapphire`, o corpus continua sendo de Emerald; isso testa roteamento, não cobertura dessas ROMs.

O teste de diagramação valida as larguras, alturas, acentos, preservação de controles e 400 combinações do Trainer Memo. O teste do carregador verifica as linhas do corpus e as descrições nativas de itens, além do registro público da fonte. Valores dinâmicos usam reservas conservadoras; o cronômetro usa campos numéricos de até três dígitos.
