pragma solidity ^0.4.18; 

//1 minute is equivalent to 1 year
//10% interest rate
//compound interest is calculated and added every year



contract loanCalculator {

    struct lender 
    {
        string name;
        uint principal;
        uint timestamp;
        uint total;
    }

    mapping (address => lender) public loan;
    address[] public loans; 

    function createloan(address addr, uint principal, string name) public {
        lender storage borrower = loan[addr];
        borrower.name = name;
        borrower.principal = principal;
        borrower.timestamp = now;
        borrower.total = principal;
        loans.push(addr);
    }

    function returnmoney(address addr, uint amount) public {
        lender storage borrower = loan[addr];
        borrower.total = borrower.total-amount;
        if(borrower.principal>borrower.total){
            borrower.principal = borrower.total;
        }
        else{

        }
    }

    
    function fracExp(uint k, uint q, uint n, uint p) internal pure returns (uint) {
        uint s = 0;
        uint N = 1;
        uint B = 1;
        for (uint i = 0; i < p; ++i){
            s += k * N / B / (q**i);
            N  = N * (n-i);
            B  = B * (i+1);
        }
        return s;
    }
    // function calculates k*(1+1/q)^n

    function calctotal(uint total, uint timenow, uint timest) internal pure returns (uint) {
        uint secs = 60;
        uint timeelapsed = timenow-timest;
        uint totall = fracExp(total, 10, timeelapsed/secs, 8);
        return totall;
    }

    function interestcalc(uint total, uint princi) internal pure returns (uint) {
        if(total>princi){
            return total-princi;
        }
        else { return 0;}
    }

    function getloandetails(address addr) view public returns (address , string, uint, uint, uint) {
        lender storage borrower = loan[addr];
        string storage name = borrower.name;
        uint princi = borrower.principal;
        uint timest = borrower.timestamp;
        uint timenow = now;
        uint total = calctotal(borrower.total, timenow, timest);
        uint interest = interestcalc(total, princi);
        return (addr, name, princi, interest, total);
    }

    function listloans() view public returns (address[], uint[], uint){
        uint[] total; 
        uint totalloan = 0;
        for (uint i=0; i < loans.length; i++) {
            lender storage borrower = loan[loans[i]];
            total.push(borrower.total);
            totalloan = totalloan + borrower.total;
        }
        return (loans, total, totalloan);
    }
    
}
