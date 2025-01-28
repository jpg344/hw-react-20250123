import React, { useState } from "react";
import logo from "./logo.svg";
import "./App.css";
import Button from "react-bootstrap/Button";
import Form from "react-bootstrap/Form";
import Dropdown from "react-bootstrap/Dropdown";
import Modal from "react-bootstrap/Modal";

function App() {
  const [variant, setVariant] = useState("success");
  const [value, setValue] = useState(50);
  const [showModal, setShowModal] = useState(false);
  const [modalContent, setModalContent] = useState("");

  const handleChange = (event) => {
    setValue(event.target.value);
  };

  function onClickChangeColor() {
    setVariant((prevVariant) =>
      prevVariant === "success" ? "danger" : "success"
    );
  }

  const handleDropdownClick = (event) => {
    event.preventDefault();
    const textValue = event.target.textContent;
    setModalContent(`You selected: ${textValue}`);
    setShowModal(true);
  };

  const handleCloseModal = () => setShowModal(false);

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>

        <Button
          variant={variant}
          onClick={onClickChangeColor}
          data-testid="change-color-button"
        >
          {variant === "success" ? "Success" : "Danger"}
        </Button>

        <div className="divider-50px" />

        <div className="form-range-a">
          <Form.Label>Range</Form.Label>
          <Form.Range
            value={value}
            onChange={handleChange}
            min={0}
            max={100}
            data-testid="range-slider"
          />
          <p>Selected Value: {value}</p>
        </div>

        <div className="divider-50px" />

        <Dropdown>
          <Dropdown.Toggle variant="success" id="dropdown-basic">
            Dropdown
          </Dropdown.Toggle>

          <Dropdown.Menu>
            <Dropdown.Item href="#/action-1" onClick={handleDropdownClick}>
              One
            </Dropdown.Item>
            <Dropdown.Item href="#/action-2" onClick={handleDropdownClick}>
              Two
            </Dropdown.Item>
            <Dropdown.Item href="#/action-3" onClick={handleDropdownClick}>
              Three
            </Dropdown.Item>
          </Dropdown.Menu>
        </Dropdown>

        {/* Modal */}
        <Modal show={showModal} onHide={handleCloseModal}>
          <Modal.Header closeButton>
            <Modal.Title>Selected Action</Modal.Title>
          </Modal.Header>
          <Modal.Body>{modalContent}</Modal.Body>
          <Modal.Footer>
            <Button variant="secondary" onClick={handleCloseModal}>
              Close
            </Button>
          </Modal.Footer>
        </Modal>

        <h1>I'm a new H1!</h1>
      </header>
    </div>
  );
}

export default App;
