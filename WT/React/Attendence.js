import React, { useState } from "react";

const Attendance = () => {
    
    const [Numbers, setNumbers] = useState(101)
    const [AbsentNumbers, setAbsentNumbers] = useState([])

    return (
        <>
            <h1>Attendance Numbers</h1>
            <br />
            <br />
            <h2>Total Individuals = {totalIndividuals}</h2>

            <button onClick={}>Present</button>
           
            <button onClick={}>Mark Absence</button>

            <h2>Absent Count = {}</h2>
            <h3>Absent Numbers:</h3>
        </>
    );
};

export default Attendance;
