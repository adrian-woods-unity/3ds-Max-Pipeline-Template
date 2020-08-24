using System;
using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace Libraries
{
    public class ViewModelBase : INotifyPropertyChanged
    {
		protected bool SetProperty<T>(ref T value, T newValue, Action<T, T> propertyChanged = null, [CallerMemberName] string propertyName = null)
		{ return SetProperty(propertyName, ref value, newValue, propertyChanged); }

		protected bool SetProperty<T>(string propertyName, ref T value, T newValue, Action<T, T> propertyChanged = null)
		{
			var result = false;

			if (!Equals(value, newValue))
			{
				var oldValue = value;
				value = newValue;

				propertyChanged?.Invoke(oldValue, newValue);

				OnPropertyChanged(propertyName);

				result = true;
			}

			return result;
		}

		public event PropertyChangedEventHandler PropertyChanged;

		protected void OnPropertyChanged(string propertyName)
		{
			OnPropertyChanged(new PropertyChangedEventArgs(propertyName));
		}

		protected virtual void OnPropertyChanged(PropertyChangedEventArgs e)
		{
			PropertyChanged?.Invoke(this, e);
		}
    }
}
