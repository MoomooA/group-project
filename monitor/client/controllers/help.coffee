Template.help.helpers
  instructions: () ->
    theme = Meteor.user().profile.theme || 'emerald'
    [
        {
            instruction: 'How do I run a simulation?'
            value:  "
        <p>Head over to the 'Optimizations' tab and select 'New Optimization'. Fill some initial parameters and you're ready to go!</p>
        <p>There are 5 parameters :
          <ul>
            <li>Tolerance: if the difference between the ratio L / D of two consecutive iteration is inferior to the tolerance, then the optimizer will pass to the next parameter.</li>
            <li>Default Step: the step which is use by the optimizer to tweak the parameters.</li>
            <li>c - Chord Length: the length of the imaginary straight line joining the leading and trailing edges of the airfoil.</li>
            <li>t - the maximum thickness of the airfoil as a fraction of the chord length c.</li>
            <li>θ - Angle of Attack: the angle between the chord line and the vector representing the relative motion between the body and the fluid through which it is moving.</li>
          </ul>
        </p>"
            images: ['images/' + theme + '/new_optimization.jpg','images/' + theme+  '/optimization_input.jpg']
      }
      {
        instruction: 'How will I know what happens during the simulation?'
        value: 'The simulation is divided into several separate processes and each one will log useful and relevant data into a Logger. These results can be viewed from the \'Logs\' section of the sidebar.'
        images: []
      }
      {
        instruction: 'Settings?'
        value: 'You can modify your settings from the available \'Settings\' icon on the sidebar.'
        images: []
      }
      {
        instruction: 'What if my question isn\'t answered here?'
        value: 'You may contact us at any of our email addresses and we will get back to you as soon as possible!'
        images: []
      }
    ]