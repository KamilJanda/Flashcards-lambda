# Flashcards-lambda

## Installing
In `App`:
```bash
build stack
```
Also run `stack ghci` or `stack exec` to use generate for generating `App/frontend/Api.elm`


In `App/frontend`:
```bash
  elm-make Main.elm --output dist/app.js
```
## Credits and acknowledgement
1. https://github.com/mattjbray/servant-elm
2. https://github.com/mattjbray/servant-elm-example-app
3. https://github.com/haskell-servant/example-servant-elm
4. https://www.elm-tutorial.org/en/02-elm-arch/01-introduction.html
5. https://haskell-servant.readthedocs.io/en/stable/tutorial/Server.html#a-first-example
6. https://guide.elm-lang.org/architecture/
7. https://github.com/Tchayen/lambda-chat
