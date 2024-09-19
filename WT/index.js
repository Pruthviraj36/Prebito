import React, { useState, useEffect } from "react";
import ReactDOM from "react-dom/client";
import "./index.css";
import reportWebVitals from "./reportWebVitals";

const apiURL = 'https://66ebce7e2b6cf2b89c5bc4b2.mockapi.io/WorldMap';

function App() {
  const [facultyData, setFacultyData] = useState([]); // Initialize with an empty array
  const [currentIndex, setCurrentIndex] = useState(0);
  const [size, setSize] = useState(300); // Initial size

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch(apiURL);
        const data = await response.json();
        setFacultyData(data);
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    };

    fetchData();
  }, []);

  const changePhotoLeft = () => {
    setCurrentIndex((prevIndex) => (prevIndex + 1) % facultyData.length);
  };

  const changePhotoRight = () => {
    setCurrentIndex((prevIndex) => (prevIndex - 1 + facultyData.length) % facultyData.length);
  };

  const increaseSize = () => {
    setSize((prevSize) => prevSize + 50);
  };

  const decreaseSize = () => {
    setSize((prevSize) => Math.max(prevSize - 50, 100));
  };

  useEffect(() => {
    const handleKeyDown = (event) => {
      if (event.key === 'ArrowLeft') {
        changePhotoRight(); // Change to right on left arrow
      }
      if (event.key === 'ArrowRight') {
        changePhotoLeft(); // Change to left on right arrow
      }
      if (event.key === 'ArrowUp') {
        increaseSize(); // Increase size on up arrow
      }
      if (event.key === 'ArrowDown') {
        decreaseSize(); // Decrease size on down arrow
      }
    };

    document.addEventListener('keydown', handleKeyDown);
    return () => {
      document.removeEventListener('keydown', handleKeyDown);
    };
  }, [facultyData]); // Add facultyData as a dependency

  // Ensure the component renders correctly when no data is available
  if (facultyData.length === 0) {
    return <div>Loading...</div>;
  }

  // Destructure the current faculty member's data
  const { avatar, city, country } = facultyData[currentIndex];

  return (
    <div style={{ textAlign: 'center', marginTop: '2rem' }}>
      <div style={{
        display: 'inline-block',
        textAlign: 'left',
        border: '1px solid #ddd',
        borderRadius: '8px',
        padding: '16px',
        width: `${size}px`,
        boxShadow: '0 4px 8px rgba(0,0,0,0.1)'
      }}>
        <img
          src={avatar}
          alt={city}
          style={{ width: '100%', height: 'auto', borderRadius: '8px' }}
        />
        <h3>{city}</h3>
        <p><strong>Country:</strong> {country}</p>
      </div>
      <div style={{ marginTop: '1rem' }}>
        <button onClick={changePhotoLeft} className="btn btn-secondary">
          Change Photo
        </button>
      </div>
      <div style={{ marginTop: '1rem' }}>
        <button onClick={increaseSize} className="btn btn-secondary">
          Increase SIZE
        </button>
        <button onClick={decreaseSize} className="btn btn-secondary" style={{ marginLeft: '10px' }}>
          Decrease SIZE
        </button>
      </div>
    </div>
  );
}

const root = ReactDOM.createRoot(document.getElementById("root"));

root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

reportWebVitals();
