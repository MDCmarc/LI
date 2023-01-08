#include <iostream>
#include <stdlib.h>
#include <algorithm>
#include <vector>

using namespace std;

#define UNDEF -1
#define TRUE 1
#define FALSE 0
#define TIMER_TO_CHANGE_HEURISTIC 3000
#define TIMER_TO_DIVIDE_CONFLICTS 100000


const void readClauses(uint& numVars, uint& numClauses, vector<vector<int>>& clauses, vector<vector<uint>>& Lista_Adj_Pos, vector<vector<uint>>& Lista_Adj_Neg, vector<uint>& Times, vector<uint>& Conflicts){
  	// Skip comments
	char c = cin.get();
  	while (c == 'c') {
    	while (c != '\n') c = cin.get();
    	c = cin.get();
  	}  

  	// Read "cnf numVars numClauses"
  	string aux;
  	cin >> aux >> numVars >> numClauses;

	//Redefine Vectors
  	clauses.resize(numClauses); 
	Lista_Adj_Neg.resize(numVars+1);
	Lista_Adj_Pos.resize(numVars+1);
	Times.resize(numVars+1,0);
	Conflicts.resize(numVars+1,0);

  	// Read clauses, update each list and total counter
  	for (uint i = 0; i < numClauses; ++i) {
    	int lit;
    	while (cin >> lit and lit != 0){
			++Times[abs(lit)];
			if (lit > 0 ) Lista_Adj_Pos[lit].push_back(i);
			else Lista_Adj_Neg[-lit].push_back(i);
      		clauses[i].push_back(lit);
    	}
  	}
}

inline const int currentValueInModel(const int& lit, const vector<int>& model){
  	if (lit >= 0) return model[lit];
  	else {
    	if (model[-lit] == UNDEF) return UNDEF;
    	else return 1 - model[-lit];
  	}
}

inline void setLiteralToTrue(const int& lit, vector<int>& model, vector<int>& modelStack){
	modelStack.push_back(lit);
  	if (lit > 0) model[lit] = TRUE;
  	else model[-lit] = FALSE;		
}

// Return 0 if propagation has no conflict
bool propagateGivesConflict (uint& indexOfNextLitToPropagate, vector<int>& modelStack, const vector<vector<uint>>& Lista_Adj_Pos, const vector<vector<uint>>& Lista_Adj_Neg, const vector<vector<int>>& clauses, vector<uint>& Conflicts, uint& timer, vector<int>& model) {

	while ( indexOfNextLitToPropagate < modelStack.size() ) {
		//Me guardo el literal a comprobar y miro todas las clausulas donde salga negada
		int lit = modelStack[indexOfNextLitToPropagate];
		++indexOfNextLitToPropagate;

		vector <uint> List;
		if (lit < 0)  List = Lista_Adj_Pos[abs(lit)];
		else List = Lista_Adj_Neg[abs(lit)];
		
		//Compruebo
    	for (uint i = 0; i < List.size(); ++i) {
      		bool someLitTrue = false;
      		int numUndefs = 0;
      		int lastLitUndef = 0;

			//Solo busco en aquellas clausulas donde se que aparece mi variable negada
      		for (uint k = 0; not someLitTrue and k < clauses[i].size(); ++k){
				const int val = currentValueInModel(clauses[List[i]][k], model);
				if (val == TRUE) someLitTrue = true;
				else if (val == UNDEF){ ++numUndefs; lastLitUndef = clauses[List[i]][k]; }
      		}

      		if (not someLitTrue and numUndefs == 0){
				++Conflicts[abs(lit)];
				++timer;
				if(timer!=0 && timer % TIMER_TO_DIVIDE_CONFLICTS ==0) for (auto& a : Conflicts) a/=2;
				return true; // conflict! all lits false
			} 
      		else if (not someLitTrue and numUndefs == 1) setLiteralToTrue(lastLitUndef,model,modelStack);	
		}    
  	}	
  	return false;
}

void backtrack(vector<int>& modelStack, vector<int>& model, uint& decisionLevel, uint& indexOfNextLitToPropagate){

	uint i = modelStack.size() -1;
  	int lit = 0;
  	while (modelStack[i] != 0){ // 0 is the DL mark
    	lit = modelStack[i];
    	model[abs(lit)] = UNDEF;
    	modelStack.pop_back();
    	--i;
  	}
  	// at this point, lit is the last decision
  	modelStack.pop_back(); // remove the DL mark
  	--decisionLevel;
  	indexOfNextLitToPropagate = modelStack.size();
  	setLiteralToTrue(-lit,model,modelStack);  // reverse last decision
}

// Heuristic for finding the next decision literal:
const int getNextDecisionLiteral( const uint& timer, const vector<uint>& Times, const vector<uint>& Conflicts, const vector<int>& model ){

	uint maxTimesConflict = 0;
	uint maxTimes = 0;
	uint maxLit = 0;

	if(timer > TIMER_TO_CHANGE_HEURISTIC){
		for (uint i = 1; i <= Times.size(); ++i){ 
			if(Conflicts[i]>maxTimesConflict && model[i]==UNDEF){
				maxLit = i;
				maxTimesConflict = Conflicts[i];
			}
		}
	}

	else {
	  	for (uint i = 1; i <= Times.size(); ++i){ 
			if(Times[i]>maxTimes && model[i]==UNDEF){
				maxLit = i;
				maxTimes = Times[i];
			}
		}	
	}

	if (model[maxLit]==UNDEF ) return maxLit;  // returns first UNDEF var, positively	
  	return 0; // reurns 0 when all literals are defined
}

inline const void checkmodel(const uint& numClauses , const vector<vector<int>>& clauses, vector<int>& model){

  	for (uint i = 0; i < numClauses; ++i){
    	bool someTrue = false;

    	for (uint j = 0; not someTrue and j < clauses[i].size(); ++j) someTrue = (currentValueInModel(clauses[i][j],model) == TRUE);
    	
		if (not someTrue) {
      		cout << "Error in model, clause is not satisfied:";
      		for (uint j = 0; j < clauses[i].size(); ++j) cout << clauses[i][j] << " ";
			cout << endl;
      		exit(1);
    	}
  	}  
}

int main(){ 

	uint numVars;
	uint numClauses;
	vector<vector<int> > clauses;
	vector<int> model;
	vector<int> modelStack;
	uint indexOfNextLitToPropagate;
	uint decisionLevel;

	vector < vector < uint> > Lista_Adj_Pos;
	vector < vector < uint> > Lista_Adj_Neg;
	vector < uint> Times;
	vector < uint> Conflicts;
	uint timer = 0;

	readClauses(numVars,numClauses,clauses,Lista_Adj_Pos,Lista_Adj_Neg,Times,Conflicts); // reads numVars, numClauses and clauses
  	model.resize(numVars+1,UNDEF);
  	indexOfNextLitToPropagate = 0;  
  	decisionLevel = 0;
  
 	 // Take care of initial unit clauses, if any
  	for (uint i = 0; i < numClauses; ++i)
    	if (clauses[i].size() == 1) {
      		const int lit = clauses[i][0];
      		const int val = currentValueInModel(lit,model);
      		if (val == FALSE) {cout << "UNSATISFIABLE" << endl; return 10;}
      		else if (val == UNDEF) setLiteralToTrue(lit,model,modelStack);
    	}
  
  	// DPLL algorithm
  	while (true) {
    	while ( propagateGivesConflict(indexOfNextLitToPropagate,modelStack,Lista_Adj_Pos,Lista_Adj_Neg,clauses,Conflicts,timer,model)) {
      		if ( decisionLevel == 0) { cout << "UNSATISFIABLE" << endl; return 10; }
      		backtrack(modelStack,model,decisionLevel,indexOfNextLitToPropagate);
    	}

    	const int decisionLit = getNextDecisionLiteral(timer,Times,Conflicts,model);
    	if (decisionLit == 0) { checkmodel(numClauses,clauses,model); cout << "SATISFIABLE" << endl; return 20; }
    	// start new decision level:
    	modelStack.push_back(0);  // push mark indicating new DL
    	++indexOfNextLitToPropagate;
    	++decisionLevel;
    	setLiteralToTrue(decisionLit,model,modelStack);    // now push decisionLit on top of the mark
  	}
}