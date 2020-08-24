using System;
using System.Windows.Controls;

namespace Wpf_Max_Sample
{
    /// <summary>
    /// Interaction logic for MainControl.xaml
    /// </summary>
    public partial class MainControl : UserControl
    {
        // events that 3ds Max will listen for
        public event EventHandler<string> TextTool1Event;
        public event EventHandler<string> TextTool2Event;
        public event EventHandler<WpfMaxSampleViewModel> OkayEvent;
        public event EventHandler CancelEvent;

        public MainControl()
        {
            InitializeComponent();

            DataContext = new WpfMaxSampleViewModel(this);
        }

        public void FireTextTool1Event(string arg)
        {
            TextTool1Event?.Invoke(this, arg);
        }

        public void FireTextTool2Event(string arg)
        {
            TextTool2Event?.Invoke(this, arg);
        }

        public void FireOkayEvent(WpfMaxSampleViewModel arg)
        {
            // MaxScript uses the arg parameter as the default parameter for event handling functions
            OkayEvent?.Invoke(this, arg);
        }

        public void FireCancelEvent()
        {
            // we don't care about parameters since we're just closing the window on cancel
            CancelEvent?.Invoke(this, null);
        }
    }
}
