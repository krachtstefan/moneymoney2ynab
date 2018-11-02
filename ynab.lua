--
-- MoneyMoney Export Extension
-- http://moneymoney-app.com/api/export
--
--
-- The MIT License (MIT)
--
-- Copyright (c) 2017 Stefan Kracht
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

Exporter{version          = 1.10,
         format           = MM.localizeText("OFX File for YNAB"),
         fileExtension    = "ofx",
         reverseOrder     = false,
         description      = MM.localizeText("Export an OFX file to be used for YNAB import")}

function WriteHeader (account, startDate, endDate, transactionCount)
  assert(io.write("OFXHEADER:100\n"))
  assert(io.write("DATA:OFXSGML\n"))
  assert(io.write("VERSION:160\n"))
  assert(io.write("SECURITY:NONE\n"))
  assert(io.write("ENCODING:UTF-8\n"))
  assert(io.write("CHARSET:NONE\n"))
  assert(io.write("COMPRESSION:NONE\n"))
  assert(io.write("OLDFILEUID:NONE\n"))
  assert(io.write("NEWFILEUID:NONE\n"))
  assert(io.write("<OFX>\n"))
  assert(io.write("<SIGNONMSGSRSV1>\n"))
  assert(io.write("  <SONRS>\n"))
  assert(io.write("    <STATUS>\n"))
  assert(io.write("      <CODE>0\n"))
  assert(io.write("      <SEVERITY>INFO\n"))
  assert(io.write("    </STATUS>\n"))
  assert(io.write("    <DTSERVER>20170426072808\n"))
  assert(io.write("    <LANGUAGE>ENG\n"))
  assert(io.write("  </SONRS>\n"))
  assert(io.write("</SIGNONMSGSRSV1>\n"))
  assert(io.write("<BANKMSGSRSV1>\n"))
  assert(io.write("  <STMTTRNRS>\n"))
  assert(io.write("    <TRNUID>1\n"))
  assert(io.write("    <STATUS>\n"))
  assert(io.write("      <CODE>0\n"))
  assert(io.write("      <SEVERITY>INFO\n"))
  assert(io.write("    </STATUS>\n"))
  assert(io.write("    <STMTRS>\n"))
  assert(io.write("      <CURDEF>EUR\n"))
  assert(io.write("      <BANKACCTFROM>\n"))
  assert(io.write("        <BANKID>",account.bankCode, "\n"))
  assert(io.write("        <ACCTID>", account.accountNumber, "\n"))
  assert(io.write("        <ACCTTYPE>CHECKING\n"))
  assert(io.write("      </BANKACCTFROM>\n"))
  assert(io.write("      <BANKTRANLIST>\n"))
  assert(io.write("        <DTSTART>", os.date("%Y%m%d", startDate), "\n"))
  assert(io.write("        <DTEND>", os.date("%Y%m%d", endDate), "\n"))
end

function WriteTransactions (account, transactions)
  for _,transaction in ipairs(transactions) do
    if transaction.booked then
      trntype = transaction.amount > 0 and "CREDIT" or "DEBIT"
      assert(io.write("        <STMTTRN>\n"))
      assert(io.write("          <TRNTYPE>", trntype, "\n"))
      assert(io.write("          <DTPOSTED>", os.date("%Y%m%d", transaction.bookingDate), "\n"))
      assert(io.write("          <TRNAMT>", transaction.amount, "\n"))
      assert(io.write("          <FITID>", transaction.id, "\n"))
      assert(io.write("          <NAME>", transaction.name, "\n"))
      assert(io.write("          <MEMO>", transaction.purpose, "\n"))
      assert(io.write("        </STMTTRN>\n"))
    end
  end
end

function WriteTail (account)
  assert(io.write("        </BANKTRANLIST>\n"))
  assert(io.write("        <LEDGERBAL>\n"))
  assert(io.write("          <BALAMT>", account.balance, "\n"))
  assert(io.write("          <DTASOF>20170327\n"))
  assert(io.write("        </LEDGERBAL>\n"))
  assert(io.write("      </STMTRS>\n"))
  assert(io.write("    </STMTTRNRS>\n"))
  assert(io.write("  </BANKMSGSRSV1>\n"))
  assert(io.write("</OFX>"))
end
