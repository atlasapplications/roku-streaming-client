<div align="center">
<img src="images/channel-poster_fhd.png" width=175 alt="Project Icon"><br><br>
<h1>Sassafras TV</h1>
<h3>An Example Roku Streaming Client</h3>
</div>

## Overview
Welcome to *Sassafras TV*, an example Roku channel that demonstrates various UI/UX design principles using the Roku SceneGraph SDK and BrightScript.

### Data-Driven Architecture
The UI's structure is built around the parsed JSON that it receives. The video titles, descriptions, number of components, and so on is all dynamic and parameterized based off its data source. 

### Asynchronous Loading
The UI is loaded on the render thread (main thread). On a separate thread, the data for the channel is loaded. Whether it's an API waiting for a network response, or loading something from disk, this asynchronous operation ensures that the UI is responsive as quickly as possible and is designed for the data to populate the UI as it comes in.

### Reusable UI Components
Each UI component is modular and contained so it can be reused in other locations. As more devices are supported, this will help for changing what components are used on what devices to handle feature degradation gracefully if a device doesn't support a component.