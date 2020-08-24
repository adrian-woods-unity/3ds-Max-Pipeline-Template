using System;
using System.IO;
using System.Reflection;
using Libraries;
using Microsoft.Expression.Interactivity.Core;
using System.Windows.Input;
using System.Windows.Media.Imaging;

namespace Wpf_Max_Sample
{
    public class WpfMaxSampleViewModel : ViewModelBase
    {
        private readonly MainControl _userControl;

        public WpfMaxSampleViewModel(MainControl userControl)
        {
            _userControl = userControl;
            _propertyTextTool1Text = "Text 1 default text";
            _propertyTextTool2Text = "Text 2 default text";

            // we need to be able to pass the absolute path to the icon so MaxScript can use it
            var absoluteUri = new Uri(new Uri(Assembly.GetExecutingAssembly().Location), @"LargeUnityIcon.png");
            ImageSource = new BitmapImage(absoluteUri);
            ImageOpacityDisplay = 100f;
        }

        // properties
        #region public string TextTool1Text (INotifyPropertyChanged)
        private string _propertyTextTool1Text;
        public string TextTool1Text
        {
            get => _propertyTextTool1Text;
            set => SetProperty(ref _propertyTextTool1Text, value);
        }
        #endregion

        #region public string TextTool2Text (INotifyPropertyChanged)
        private string _propertyTextTool2Text;
        public string TextTool2Text
        {
            get => _propertyTextTool2Text;
            set => SetProperty(ref _propertyTextTool2Text, value);
        }
        #endregion

        #region public BitmapSource ImageSource (INotifyPropertyChanged)
        private BitmapSource _propertyImageSource;
        public BitmapSource ImageSource
        {
            get => _propertyImageSource;
            set => SetProperty(ref _propertyImageSource, value);
        }
        #endregion

        #region public float ImageOpacity (INotifyPropertyChanged)
        private float _propertyImageOpacity;
        public float ImageOpacity
        {
            get => _propertyImageOpacity;
            set => SetProperty(ref _propertyImageOpacity, value);
        }
        #endregion

        #region public float ImageOpacityDisplay (INotifyPropertyChanged w/ OnChanged)
        private float _propertyImageOpacityDisplay;
        public float ImageOpacityDisplay
        {
            get => _propertyImageOpacityDisplay;
            set => SetProperty(ref _propertyImageOpacityDisplay, value, (oldValue, newValue) => ImageOpacityDisplayExecute(_propertyImageOpacityDisplay, value));
        }
        #endregion

        public void ImageOpacityDisplayExecute(float oldValue, float newValue)
        {
            ImageOpacity = newValue / 100f;
        }

        // commands
        #region public ICommand TextTool1Go;
        ActionCommand _actionTextTool1Go;
        public ICommand TextTool1Go => _actionTextTool1Go ?? (_actionTextTool1Go = new ActionCommand(TextTool1GoExecute));
        #endregion

        void TextTool1GoExecute()
        {
            // Fire the event that MaxScript is listening to
            _userControl.FireTextTool1Event(TextTool1Text);
        }

        #region public ICommand TextTool2Go;
        ActionCommand _actionTextTool2Go;
        public ICommand TextTool2Go => _actionTextTool2Go ?? (_actionTextTool2Go = new ActionCommand(TextTool2GoExecute));
        #endregion

        void TextTool2GoExecute()
        {
            // Fire the event that MaxScript is listening to
            _userControl.FireTextTool2Event(TextTool2Text);
        }

        #region public ICommand Okay;
        ActionCommand _actionOkay;
        public ICommand Okay => _actionOkay ?? (_actionOkay = new ActionCommand(OkayExecute));
        #endregion

        void OkayExecute()
        {
            _userControl.FireOkayEvent(this);
        }

        #region public ICommand Cancel;
        ActionCommand _actionCancel;
        public ICommand Cancel => _actionCancel ?? (_actionCancel = new ActionCommand(CancelExecute));
        #endregion

        void CancelExecute()
        {
            _userControl.FireCancelEvent();
        }
    }
}
