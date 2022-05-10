/*********************************************
 * OPL 12.6.0.0 Model
 * Author: temporaryuser
 * Creation Date: May 2, 2022 at 9:23:49 PM
*********************************************/
int NumberOfBoxes = ...;
range B = 1 .. NumberOfBoxes;
float data[B][1 .. 4] = ...;
float LC[b in B] = data[b][4];
float W[b in B] = data[b][3];
float H[b in B] = data[b][2];

int numberOfMatrixPermutations;
int numberOfMatrixIndividualPermutationsIndex[1 .. NumberOfBoxes][1 .. 3];
execute CalculatingNumberOfPermutations {
    function factorial(x) {
        var xx = 1;
        for ( var i = 1; i <= x; i++) {
            xx = xx * i;
        }
        return xx;
    }
    function perm(n, r) {
        return factorial(n) / factorial(n - r);
    }

    var temp;
    for ( var i = 1; i <= NumberOfBoxes; i++) {
        temp = perm(NumberOfBoxes, i);
        numberOfMatrixPermutations = numberOfMatrixPermutations + temp;

        numberOfMatrixIndividualPermutationsIndex[i][1] = temp;
    }

    numberOfMatrixIndividualPermutationsIndex[1][2] = 1;
    numberOfMatrixIndividualPermutationsIndex[1][3] = numberOfMatrixIndividualPermutationsIndex[1][1];

    if (NumberOfBoxes > 1) {
        for ( var i = 2; i <= NumberOfBoxes; i++) {
            numberOfMatrixIndividualPermutationsIndex[i][2] = numberOfMatrixIndividualPermutationsIndex[i - 1][3] + 1;
            numberOfMatrixIndividualPermutationsIndex[i][3] = numberOfMatrixIndividualPermutationsIndex[i][1]
                    + numberOfMatrixIndividualPermutationsIndex[i][2] - 1;
        }
    }


}

tuple PermutationsCollectionType {
  {int} box;
}
PermutationsCollectionType PermutationsCollection[1 .. numberOfMatrixPermutations];

execute CreatePermutationCollection {


    function visualizeMatrix3d(temp_matrix) {
        writeln();
        for ( var k = 0; k < temp_matrix[1][1].length; k++) {
            writeln("k=", k);
            for ( var i = 0; i < temp_matrix.length; i++) {
                write("[");
                for ( var j = 0; j < temp_matrix[1].length; j++) {
                    write(temp_matrix[i][j][k], " ");
                }
                write("]");
                writeln();
            }
        }
    }
    function visualizeMatrix2d(temp_matrix) {
        writeln();
        for ( var i = 0; i < temp_matrix.length; i++) {
            write("[");
            for ( var j = 0; j < temp_matrix[1].length; j++) {
                write(temp_matrix[i][j], " ");
            }
            write("]");
            writeln();
        }
    }
    function factorial(x) {
        var xx = 1;
        for ( var i = 1; i <= x; i++) {
            xx = xx * i;
        }
        return xx;
    }
    function perm(n, r) {
        return factorial(n) / factorial(n - r);
    }
    function power(x, y) {
        var value = x;
        for ( var i = 1; i < y; i++) {
            value = value * x;
        }
        return value;
    }

    function initialize_temp_matrix(sizeOfMatrixI, NumberOfBoxes, iteration,
            iterationMinusOne) {
        var temp_matrix = new Array(power(sizeOfMatrixI, iterationMinusOne));
        for ( var i = 0; i < power(sizeOfMatrixI, iterationMinusOne); i++) {
            temp_matrix[i] = new Array(iteration);
            for ( var j = 0; j < iteration; j++) {
                temp_matrix[i][j] = new Array(NumberOfBoxes);
                for ( var k = 0; k < NumberOfBoxes; k++) {
                    temp_matrix[i][j][k] = 0;
                }
            }
        }
        return temp_matrix;
    }
    function initialize_temp_matrix2(sizeOfMatrixI, NumberOfBoxes, iteration) {
        var temp = iteration;
        var temp_matrix2 = new Array(sizeOfMatrixI * NumberOfBoxes);
        for ( var i = 0; i < sizeOfMatrixI * NumberOfBoxes; i++) {
            temp_matrix2[i] = new Array(iteration);
            for ( var j = 0; j < iteration; j++) {
                temp_matrix2[i][j] = 0;
            }
        }
        return temp_matrix2;
    }
    function initialize_temp_matrix3(NumberOfBoxes, iteration) {
        var temp_matrix3 = new Array(perm(NumberOfBoxes, iteration));
        for ( var i = 0; i < perm(NumberOfBoxes, iteration); i++) {
            temp_matrix3[i] = new Array(iteration);
            for ( var j = 0; j < iteration; j++) {
                temp_matrix3[i][j] = 0;
            }
        }
        return temp_matrix3;
    }
    function initialize_temp_matrix4(countDuplicates2Count, columns) {
        var temp_matrix4 = new Array(countDuplicates2Count);
        for ( var a = 0; a < countDuplicates2Count; a++) {
            temp_matrix4[a] = new Array(columns);
            for ( var b = 0; b < columns; b++) {
                temp_matrix4[a][b] = 0;
            }
        }
        return temp_matrix4;
    }

    var iterationMinusOne = iteration - 1;

    for ( var iteration = 1; iteration <= NumberOfBoxes; iteration++) {
        if (iteration == 1) {
            var matrix = new Array(NumberOfBoxes);
            for ( var i = 0; i < NumberOfBoxes; i++) {
                matrix[i] = new Array(1);
                for ( var j = 0; j < 1; j++) {
                    matrix[i][j] = i;
                }
            }
            var temp;
            for ( var i = 0; i < matrix.length; i++) {
                temp = matrix[i][0] + 1;
                PermutationsCollection[i + 1].box.add(temp);
            }
        } else {
            var temp_matrix = initialize_temp_matrix(matrix.length,
                    NumberOfBoxes, iteration, iterationMinusOne);
            for ( var i = 0; i < temp_matrix.length; i++) {
                for ( var j = 0; j < NumberOfBoxes; j++) {
                    temp_matrix[i][0][j] = j;
                    for ( var k = 0; k < iteration - 1; k++) {
                        temp_matrix[i][k + 1][j] = matrix[i][k];
                    }
                }
            }
            //visualizeMatrix3d(temp_matrix);

            var temp_matrix2 = initialize_temp_matrix2(matrix.length,
                    NumberOfBoxes, iteration);
            for ( var i = 0; i < temp_matrix.length; i++) {
                for ( var j = 0; j < NumberOfBoxes; j++) {
                    for ( var k = 0; k < iteration; k++) {
                        temp_matrix2[(j) * temp_matrix.length + i][k] = temp_matrix[i][k][j];
                    }
                }
            }
            //visualizeMatrix2d(temp_matrix2);

            var temp_matrix3 = initialize_temp_matrix3(NumberOfBoxes, iteration);
            var rowCount = 0;
            for ( var i = 0; i < temp_matrix2.length; i++) {
                var countDuplicates = 0;
                for ( var j = 0; j < temp_matrix2[1].length; j++) {
                    for ( var jj = 0; jj < temp_matrix2[1].length; jj++) {
                        if (temp_matrix2[i][j] == temp_matrix2[i][jj]
                                && j != jj) {
                            countDuplicates++;
                        }
                    }
                }

                //Eliminate permutations that go beyond the weight limit
                var weightSum = new Array(2);
                for ( var ii = 0; ii < 2; ii++) {
                    weightSum[ii] = new Array(temp_matrix2[1].length);
                    for ( var j = 0; j < temp_matrix2[1].length; j++) {
                        weightSum[ii][j] = 0;
                    }
                }
                for ( var j = 0; j < temp_matrix2[1].length; j++) {
                    weightSum[0][j] = W[temp_matrix2[i][j] + 1];
                }
                weightSum[1][temp_matrix2[1].length - 1] = weightSum[0][temp_matrix2[1].length - 1];
                for ( var j = temp_matrix2[1].length - 1; j > 0; j--) {
                    weightSum[1][j] = weightSum[0][j] + weightSum[1][j + 1];
                }
                for ( var j = 0; j < temp_matrix2[1].length; j++) {
                    if (LC[temp_matrix2[i][j] + 1] < weightSum[1][j + 1]) {
                        countDuplicates++;
                    }
                }
                //Eliminate permutations that go beyond the weight limit END

                if (countDuplicates == 0) {
                    for ( var j = 0; j < temp_matrix2[1].length; j++) {
                        temp_matrix3[rowCount][j] = temp_matrix2[i][j];
                    }
                    rowCount++;
                }
            }
            //visualizeMatrix2d(temp_matrix3);

            var countDuplicates2 = new Array(temp_matrix3.length);
            for ( var i = 0; i < temp_matrix3.length; i++) {
                countDuplicates2[i] = 0;
                for ( var j = 0; j < temp_matrix3[1].length; j++) {
                    for ( var jj = 0; jj < temp_matrix3[1].length; jj++) {
                        if (temp_matrix3[i][j] == temp_matrix3[i][jj]
                                && j != jj) {
                            countDuplicates2[i] = countDuplicates2[i] + 1;
                        }
                    }
                }
            }
            var countDuplicates2Count = 0;
            for ( var i = 0; i < temp_matrix3.length; i++) {
                if (countDuplicates2[i] == 0) {
                    countDuplicates2Count++;
                }
            }

            if (countDuplicates2Count < temp_matrix3.length) {

	            var temp_matrix4 = initialize_temp_matrix4(countDuplicates2Count,
	                    temp_matrix3[0].length);
	            var count2 = 0;
	            for ( var i = 0; i < temp_matrix3.length; i++) {
	                if (countDuplicates2[i] == 0) {
	                    for ( var j = 0; j < temp_matrix3[0].length; j++) {
	                        temp_matrix4[count2][j] = temp_matrix3[i][j];
	                    }
	                    count2++;
	                }
	            }
	            //visualizeMatrix2d(temp_matrix4);
	            
	            var matrix = temp_matrix4;
            }
            else{
            	var matrix = temp_matrix3;        
            }

            //var matrix = temp_matrix3;

            for ( var i = 0; i < matrix.length; i++) {
                for ( var j = 0; j < matrix[1].length; j++) {
                    PermutationsCollection[i
                            + numberOfMatrixIndividualPermutationsIndex[iteration][2]].box
                            .add(matrix[i][j] + 1);
                }
            }

        }
        writeln(iteration);
        writeln("Permutations per type:",numberOfMatrixIndividualPermutationsIndex);
		writeln((numberOfMatrixIndividualPermutationsIndex[iteration][2])/numberOfMatrixPermutations);
    }
    

}

/*Testing tuple PermutationsCollectionType2{
	PermutationsCollectionType perm;
	int box;
}*/
{PermutationsCollectionType} Omega = {PermutationsCollection[i] | i in 1 .. numberOfMatrixPermutations:card(PermutationsCollection[i].box)>0};
//Testing {PermutationsCollectionType2} Omega2={<o,b>|o in Omega,b in o.box};

dvar boolean x[Omega][B];
dvar float+ TotalHeight;
dvar boolean XX[B];

//Testing dvar boolean xx[Omega2];

maximize TotalHeight;
subject to{
	
	//Testing TotalHeight==sum(o in Omega2)(H[o.box]*xx[o]);

	TotalHeight==sum(o in Omega,b in B,bb in o.box:b==bb)(H[bb]*x[o][bb]);
	
	forall(b in B){
		sum(o in Omega,bb in o.box:bb==b)(x[o][bb])<=1;//eq1
		sum(o in Omega,ii in B:card(o.box)==ii && item(o.box,0)==b)(x[o][b])<=1;//eq2
	}
	
	forall(o in Omega:card(o.box)>1){
		sum(bb in 2..(card(o.box)))(x[o][item(o.box,bb-1)])==(card(o.box)-1)*x[o][item(o.box,0)];//eq4
		
		forall(i in 1..(card(o.box)-1))
			LC[item(o.box,i-1)]*x[o][item(o.box,i-1)]>=sum(bb in i..(card(o.box)-1))(W[item(o.box,bb)]*x[o][item(o.box,bb)]);//eq5
	}
	
	sum(o in Omega:card(o.box)==1)(x[o][item(o.box,0)])<=1;//eq6
	
	forall(i in B){
		sum(o in Omega, b in B:card(o.box)==i)(x[o][b])>=XX[i];//eq7_1
		sum(o in Omega, b in B:card(o.box)==i)(x[o][b])<=i*XX[i];//eq7_2
	}
	
	sum(b in B)(XX[b])<=1;//eq8

}


