superlog = log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold gre$
pwdcp = pwd | pbcopy
alias = ! git config --get-regexp ^alias\\. | sed -e s/^alias\\.// -e s/\\ /\\ =\\ /
b = ! git branch | grep \\* | cut -d ' ' -f2
bD = ! git branch -D
lc = ! git log -1 --format=%cd
cp = ! git cherry-pick
p = ! git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)
n = ! git checkout -b
c = ! git checkout
s = ! git status
l = ! git log --reverse HEAD~5..HEAD --pretty=format:"%h - %an, %ar : %s"
d = ! git diff
resett = ! git reset --soft HEAD~1
