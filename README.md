# moneymoney2ynab

[MoneyMoney](https://moneymoney-app.com/) Extension to export a OFX file that is optimized to work for [YNAB](https://www.youneedabudget.com/) import.

Next to MoneyMoneys native OFX-Export this extensions is optimized to work for YNAB. It excludes all planned transactions   

## Installation

- Open MoneyMoney `Hilfe` menu and click on `Zeige Datenbank im Finder`
- Put the `ynab.lua` file in the `Extensions` folder
- no app restart required

## Export usage
- Open MoneyMoney and select the account you want to export
- optionally adjust date range, category, etc.
- select `Konto` -> `Umsätze exportieren` in the menu
- pick a filename and select the type `OFX-Datei for YNAB (.ofx)`

## Import usage
- Open the YNAB web app
- choose the account you want to import to 
- click the `import` button on the top of the transaction list
- import the `.ofx` you created before

