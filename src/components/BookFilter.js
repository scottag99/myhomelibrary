import React from 'react';
import { observer } from 'mobx-react';
import { Checkbox, FormControl, ControlLabel, Row, Col, Radio, FormGroup } from 'react-bootstrap';

export default observer(({store}) => (
  <Row>
    <h3>Find Books</h3>
    <Col sm={4} lg={2}>
      <Checkbox value='PreK-K' checked={store.readingLevels['PreK-K']} onChange={store.handleGradeLevel}>
        PreK-K
      </Checkbox>
      <Checkbox value='G1-G2' checked={store.readingLevels['G1-G2']} onChange={store.handleGradeLevel}>
        G1-G2
      </Checkbox>
      <Checkbox value='G3-G5' checked={store.readingLevels['G3-G5']} onChange={store.handleGradeLevel}>
        G3-G5
      </Checkbox>
      <FormGroup>
        <Radio name="bilingual-filter" id="all" onChange={store.handleBilingualFilter}>All</Radio>
        <Radio name="bilingual-filter" id="bilingual" onChange={store.handleBilingualFilter}>Bilingual</Radio>
        <Radio name="bilingual-filter" id="english" onChange={store.handleBilingualFilter}>English Only</Radio>
      </FormGroup>
    </Col>
    <Col sm={4} lg={3}>
      <ControlLabel>Filter by GRL</ControlLabel>
      <FormControl componentClass="select" placeholder="Select" onChange={store.handleGrlFilter} value={store.grlFilter}>
        <option value="">Select</option>
        <option value="A">A</option>
        <option value="B">B</option>
        <option value="C">C</option>
        <option value="D">D</option>
        <option value="E">E</option>
        <option value="F">F</option>
        <option value="G">G</option>
        <option value="H">H</option>
        <option value="I">I</option>
        <option value="J">J</option>
        <option value="K">K</option>
        <option value="L">L</option>
        <option value="M">M</option>
        <option value="N">N</option>
        <option value="O">O</option>
        <option value="P">P</option>
        <option value="Q">Q</option>
        <option value="R">R</option>
        <option value="S">S</option>
        <option value="T">T</option>
        <option value="U">U</option>
        <option value="V">V</option>
        <option value="W">W</option>
        <option value="X">X</option>
        <option value="Y">Y</option>
        <option value="Z">Z</option>
      </FormControl>
    </Col>
    <Col sm={4} lg={3}>
      <ControlLabel inline>Filter by DRA</ControlLabel>
      <FormControl componentClass="select" placeholder="Select" onChange={store.handleDraFilter} value={store.draFilter}>
        <option value="">Select</option>
        <option value="1">1</option>
        <option value="2">2</option>
        <option value="3">3</option>
        <option value="4">4</option>
        <option value="6">6</option>
        <option value="8">8</option>
        <option value="10">10</option>
        <option value="12">12</option>
        <option value="14">14</option>
        <option value="16">16</option>
        <option value="18">18</option>
        <option value="20">20</option>
        <option value="22">22</option>
        <option value="24">24</option>
        <option value="26">26</option>
        <option value="28">28</option>
        <option value="30">30</option>
        <option value="32">32</option>
        <option value="34">34</option>
        <option value="36">36</option>
        <option value="38">38</option>
        <option value="40">40</option>
        <option value="50">50</option>
        <option value="60">60</option>
        <option value="70">70</option>
        <option value="80">80</option>
      </FormControl>
    </Col>
  </Row>
));
