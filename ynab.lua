--
-- MoneyMoney Export Extension
-- http://moneymoney-app.com/api/export
--
--
-- The MIT License (MIT)
--
-- Copyright (c) 2014 Boris Penck
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
--
-- Export a ofx file to be used for YNAB import (skippes all planned transactions)
--

Exporter{version          = 1.00,
         format           = MM.localizeText("OFX-Datei for YNAB"),
         fileExtension    = "ofx",
         reverseOrder     = false,
         description      = MM.localizeText("Export a ofx file to be used for YNAB import")}

function WriteHeader (account, startDate, endDate, transactionCount)
  assert(io.write([[
		OFXHEADER:100
		DATA:OFXSGML
		VERSION:102
		SECURITY:NONE
		ENCODING:USASCII
		CHARSET:1252
		COMPRESSION:NONE
		OLDFILEUID:NONE
		NEWFILEUID:NONE

    <OFX>
    <SIGNONMSGSRSV1>
      <SONRS>
        <STATUS>
          <CODE>0
          <SEVERITY>INFO
        </STATUS>
        <DTSERVER>20170426072808
        <LANGUAGE>ENG
      </SONRS>
    </SIGNONMSGSRSV1>
    <BANKMSGSRSV1>
      <STMTTRNRS>
        <TRNUID>1
        <STATUS>
          <CODE>0
          <SEVERITY>INFO
        </STATUS>
        <STMTRS>
          <CURDEF>EUR
          <BANKACCTFROM>
            <BANKID>]].. transaction.bankCode ..[[
            <ACCTID>]].. transaction.accountNumber ..[[
            <ACCTTYPE>CHECKING
          </BANKACCTFROM>
          <BANKTRANLIST>
            <DTSTART>]].. os.date("%Y%m%d", startDate) .. [[
            <DTEND>]].. os.date("%Y%m%d", endDate) .. [[
  ]]))
end

function WriteTransactions (account, transactions)
  for _,transaction in ipairs(transactions) do

    trntype = transaction.amount > 0 and "CREDIT" or "DEBIT"

    assert(io.write([[
      <STMTTRN>
        <TRNTYPE>]].. trntype ..[[
        <DTPOSTED>]].. os.date("%Y%m%d", transaction.bookingDate) .. [[
        <TRNAMT>]] .. transaction.amount .. [[
        <FITID>]] .. transaction.id .. [[ 
        <NAME>]] .. transaction.name .. [[
        <MEMO>]] .. transaction.comment .. [[
      </STMTTRN>
    ]]))
  end
end

function WriteTail (account)
  assert(io.write([[
            </BANKTRANLIST>
            <LEDGERBAL>
              <BALAMT>]].. account.balance ..[[
              <DTASOF>20170327
            </LEDGERBAL>
          </STMTRS>
        </STMTTRNRS>
      </BANKMSGSRSV1>
    </OFX>
  ]]))
end