﻿#pragma warning disable 1591
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.269
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace FeedbackScript.Admin.Models
{
	using System.Data.Linq;
	using System.Data.Linq.Mapping;
	using System.Data;
	using System.Collections.Generic;
	using System.Reflection;
	using System.Linq;
	using System.Linq.Expressions;
	using System.ComponentModel;
	using System;
	
	
	[global::System.Data.Linq.Mapping.DatabaseAttribute(Name="FeedbackScript")]
	public partial class FeedbackreportsDataContext : System.Data.Linq.DataContext
	{
		
		private static System.Data.Linq.Mapping.MappingSource mappingSource = new AttributeMappingSource();
		
    #region Extensibility Method Definitions
    partial void OnCreated();
    partial void InsertResponse(Response instance);
    partial void UpdateResponse(Response instance);
    partial void DeleteResponse(Response instance);
    partial void InsertAudit_Log(Audit_Log instance);
    partial void UpdateAudit_Log(Audit_Log instance);
    partial void DeleteAudit_Log(Audit_Log instance);
    #endregion
		
		public FeedbackreportsDataContext() : 
				base(global::System.Configuration.ConfigurationManager.ConnectionStrings["FeedbackScriptConnectionString"].ConnectionString, mappingSource)
		{
			OnCreated();
		}
		
		public FeedbackreportsDataContext(string connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public FeedbackreportsDataContext(System.Data.IDbConnection connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public FeedbackreportsDataContext(string connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public FeedbackreportsDataContext(System.Data.IDbConnection connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public System.Data.Linq.Table<Response> Responses
		{
			get
			{
				return this.GetTable<Response>();
			}
		}
		
		public System.Data.Linq.Table<Audit_Log> Audit_Logs
		{
			get
			{
				return this.GetTable<Audit_Log>();
			}
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.spGetTopPages")]
		public ISingleResult<spGetTopPagesResult> spGetTopPages([global::System.Data.Linq.Mapping.ParameterAttribute(Name="FromDate", DbType="DateTime")] System.Nullable<System.DateTime> fromDate, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="ToDate", DbType="DateTime")] System.Nullable<System.DateTime> toDate)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), fromDate, toDate);
			return ((ISingleResult<spGetTopPagesResult>)(result.ReturnValue));
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.spSummaryPages")]
		public ISingleResult<spSummaryPagesResult> spSummaryPages([global::System.Data.Linq.Mapping.ParameterAttribute(Name="FromDate", DbType="DateTime")] System.Nullable<System.DateTime> fromDate, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="ToDate", DbType="DateTime")] System.Nullable<System.DateTime> toDate)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), fromDate, toDate);
			return ((ISingleResult<spSummaryPagesResult>)(result.ReturnValue));
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.spGetSearchPages")]
		public ISingleResult<spGetSearchPagesResult> spGetSearchPages([global::System.Data.Linq.Mapping.ParameterAttribute(Name="FromDate", DbType="DateTime")] System.Nullable<System.DateTime> fromDate, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="ToDate", DbType="DateTime")] System.Nullable<System.DateTime> toDate, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="URLContains", DbType="VarChar(1024)")] string uRLContains, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="SelectedAgency", DbType="VarChar(100)")] string selectedAgency)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), fromDate, toDate, uRLContains, selectedAgency);
			return ((ISingleResult<spGetSearchPagesResult>)(result.ReturnValue));
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.spGetComments")]
		public ISingleResult<spGetCommentsResult> spGetComments([global::System.Data.Linq.Mapping.ParameterAttribute(Name="URL", DbType="NVarChar(1024)")] string uRL, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="FromDate", DbType="DateTime")] System.Nullable<System.DateTime> fromDate, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="ToDate", DbType="DateTime")] System.Nullable<System.DateTime> toDate)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), uRL, fromDate, toDate);
			return ((ISingleResult<spGetCommentsResult>)(result.ReturnValue));
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.spGetAgencyList")]
		public ISingleResult<spGetAgencyListResult> spGetAgencyList([global::System.Data.Linq.Mapping.ParameterAttribute(Name="FromDate", DbType="DateTime")] System.Nullable<System.DateTime> fromDate, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="ToDate", DbType="DateTime")] System.Nullable<System.DateTime> toDate)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), fromDate, toDate);
			return ((ISingleResult<spGetAgencyListResult>)(result.ReturnValue));
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.spGetTrendResults")]
		public ISingleResult<spGetTrendResultsResult> spGetTrendResults([global::System.Data.Linq.Mapping.ParameterAttribute(Name="FromDate", DbType="DateTime")] System.Nullable<System.DateTime> fromDate, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="ToDate", DbType="DateTime")] System.Nullable<System.DateTime> toDate, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="URLContains", DbType="VarChar(1024)")] string uRLContains, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="SelectedAgency", DbType="VarChar(100)")] string selectedAgency, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="UnitType", DbType="Char(1)")] System.Nullable<char> unitType, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="CustomOrder", DbType="Char(1)")] System.Nullable<char> customOrder)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), fromDate, toDate, uRLContains, selectedAgency, unitType, customOrder);
			return ((ISingleResult<spGetTrendResultsResult>)(result.ReturnValue));
		}
	}
	
	[global::System.Data.Linq.Mapping.TableAttribute(Name="dbo.Responses")]
	public partial class Response : INotifyPropertyChanging, INotifyPropertyChanged
	{
		
		private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
		
		private long _Id;
		
		private string _Url;
		
		private System.DateTime _UtcDate;
		
		private System.Nullable<bool> _Positive;
		
		private string _Comment;
		
    #region Extensibility Method Definitions
    partial void OnLoaded();
    partial void OnValidate(System.Data.Linq.ChangeAction action);
    partial void OnCreated();
    partial void OnIdChanging(long value);
    partial void OnIdChanged();
    partial void OnUrlChanging(string value);
    partial void OnUrlChanged();
    partial void OnUtcDateChanging(System.DateTime value);
    partial void OnUtcDateChanged();
    partial void OnPositiveChanging(System.Nullable<bool> value);
    partial void OnPositiveChanged();
    partial void OnCommentChanging(string value);
    partial void OnCommentChanged();
    #endregion
		
		public Response()
		{
			OnCreated();
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Id", AutoSync=AutoSync.OnInsert, DbType="BigInt NOT NULL IDENTITY", IsPrimaryKey=true, IsDbGenerated=true)]
		public long Id
		{
			get
			{
				return this._Id;
			}
			set
			{
				if ((this._Id != value))
				{
					this.OnIdChanging(value);
					this.SendPropertyChanging();
					this._Id = value;
					this.SendPropertyChanged("Id");
					this.OnIdChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Url", DbType="NVarChar(1024) NOT NULL", CanBeNull=false)]
		public string Url
		{
			get
			{
				return this._Url;
			}
			set
			{
				if ((this._Url != value))
				{
					this.OnUrlChanging(value);
					this.SendPropertyChanging();
					this._Url = value;
					this.SendPropertyChanged("Url");
					this.OnUrlChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_UtcDate", DbType="DateTime NOT NULL")]
		public System.DateTime UtcDate
		{
			get
			{
				return this._UtcDate;
			}
			set
			{
				if ((this._UtcDate != value))
				{
					this.OnUtcDateChanging(value);
					this.SendPropertyChanging();
					this._UtcDate = value;
					this.SendPropertyChanged("UtcDate");
					this.OnUtcDateChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Positive", DbType="Bit")]
		public System.Nullable<bool> Positive
		{
			get
			{
				return this._Positive;
			}
			set
			{
				if ((this._Positive != value))
				{
					this.OnPositiveChanging(value);
					this.SendPropertyChanging();
					this._Positive = value;
					this.SendPropertyChanged("Positive");
					this.OnPositiveChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Comment", DbType="NVarChar(255)")]
		public string Comment
		{
			get
			{
				return this._Comment;
			}
			set
			{
				if ((this._Comment != value))
				{
					this.OnCommentChanging(value);
					this.SendPropertyChanging();
					this._Comment = value;
					this.SendPropertyChanged("Comment");
					this.OnCommentChanged();
				}
			}
		}
		
		public event PropertyChangingEventHandler PropertyChanging;
		
		public event PropertyChangedEventHandler PropertyChanged;
		
		protected virtual void SendPropertyChanging()
		{
			if ((this.PropertyChanging != null))
			{
				this.PropertyChanging(this, emptyChangingEventArgs);
			}
		}
		
		protected virtual void SendPropertyChanged(String propertyName)
		{
			if ((this.PropertyChanged != null))
			{
				this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
			}
		}
	}
	
	[global::System.Data.Linq.Mapping.TableAttribute(Name="dbo.Audit_Logs")]
	public partial class Audit_Log : INotifyPropertyChanging, INotifyPropertyChanged
	{
		
		private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
		
		private int _Log_ID;
		
		private System.Nullable<System.DateTime> _Log_Datetime;
		
		private string _User_identity;
		
		private string _User_Action;
		
		private string _User_Parameters;
		
		private System.Nullable<bool> _Event_Result;
		
    #region Extensibility Method Definitions
    partial void OnLoaded();
    partial void OnValidate(System.Data.Linq.ChangeAction action);
    partial void OnCreated();
    partial void OnLog_IDChanging(int value);
    partial void OnLog_IDChanged();
    partial void OnLog_DatetimeChanging(System.Nullable<System.DateTime> value);
    partial void OnLog_DatetimeChanged();
    partial void OnUser_identityChanging(string value);
    partial void OnUser_identityChanged();
    partial void OnUser_ActionChanging(string value);
    partial void OnUser_ActionChanged();
    partial void OnUser_ParametersChanging(string value);
    partial void OnUser_ParametersChanged();
    partial void OnEvent_ResultChanging(System.Nullable<bool> value);
    partial void OnEvent_ResultChanged();
    #endregion
		
		public Audit_Log()
		{
			OnCreated();
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Log_ID", AutoSync=AutoSync.OnInsert, DbType="Int NOT NULL IDENTITY", IsPrimaryKey=true, IsDbGenerated=true)]
		public int Log_ID
		{
			get
			{
				return this._Log_ID;
			}
			set
			{
				if ((this._Log_ID != value))
				{
					this.OnLog_IDChanging(value);
					this.SendPropertyChanging();
					this._Log_ID = value;
					this.SendPropertyChanged("Log_ID");
					this.OnLog_IDChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Log_Datetime", DbType="DateTime")]
		public System.Nullable<System.DateTime> Log_Datetime
		{
			get
			{
				return this._Log_Datetime;
			}
			set
			{
				if ((this._Log_Datetime != value))
				{
					this.OnLog_DatetimeChanging(value);
					this.SendPropertyChanging();
					this._Log_Datetime = value;
					this.SendPropertyChanged("Log_Datetime");
					this.OnLog_DatetimeChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_User_identity", DbType="VarChar(256)")]
		public string User_identity
		{
			get
			{
				return this._User_identity;
			}
			set
			{
				if ((this._User_identity != value))
				{
					this.OnUser_identityChanging(value);
					this.SendPropertyChanging();
					this._User_identity = value;
					this.SendPropertyChanged("User_identity");
					this.OnUser_identityChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_User_Action", DbType="VarChar(256)")]
		public string User_Action
		{
			get
			{
				return this._User_Action;
			}
			set
			{
				if ((this._User_Action != value))
				{
					this.OnUser_ActionChanging(value);
					this.SendPropertyChanging();
					this._User_Action = value;
					this.SendPropertyChanged("User_Action");
					this.OnUser_ActionChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_User_Parameters", DbType="VarChar(5000)")]
		public string User_Parameters
		{
			get
			{
				return this._User_Parameters;
			}
			set
			{
				if ((this._User_Parameters != value))
				{
					this.OnUser_ParametersChanging(value);
					this.SendPropertyChanging();
					this._User_Parameters = value;
					this.SendPropertyChanged("User_Parameters");
					this.OnUser_ParametersChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Event_Result", DbType="Bit")]
		public System.Nullable<bool> Event_Result
		{
			get
			{
				return this._Event_Result;
			}
			set
			{
				if ((this._Event_Result != value))
				{
					this.OnEvent_ResultChanging(value);
					this.SendPropertyChanging();
					this._Event_Result = value;
					this.SendPropertyChanged("Event_Result");
					this.OnEvent_ResultChanged();
				}
			}
		}
		
		public event PropertyChangingEventHandler PropertyChanging;
		
		public event PropertyChangedEventHandler PropertyChanged;
		
		protected virtual void SendPropertyChanging()
		{
			if ((this.PropertyChanging != null))
			{
				this.PropertyChanging(this, emptyChangingEventArgs);
			}
		}
		
		protected virtual void SendPropertyChanged(String propertyName)
		{
			if ((this.PropertyChanged != null))
			{
				this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
			}
		}
	}
	
	public partial class spGetTopPagesResult
	{
		
		private string _Agency;
		
		private string _URL;
		
		private System.Nullable<int> _VolumeOfFeedback;
		
		private System.Nullable<double> _Positive;
		
		private System.Nullable<double> _Negative;
		
		private System.Nullable<int> _Mean;
		
		public spGetTopPagesResult()
		{
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Agency", DbType="VarChar(9) NOT NULL", CanBeNull=false)]
		public string Agency
		{
			get
			{
				return this._Agency;
			}
			set
			{
				if ((this._Agency != value))
				{
					this._Agency = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_URL", DbType="NVarChar(1024) NOT NULL", CanBeNull=false)]
		public string URL
		{
			get
			{
				return this._URL;
			}
			set
			{
				if ((this._URL != value))
				{
					this._URL = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_VolumeOfFeedback", DbType="Int")]
		public System.Nullable<int> VolumeOfFeedback
		{
			get
			{
				return this._VolumeOfFeedback;
			}
			set
			{
				if ((this._VolumeOfFeedback != value))
				{
					this._VolumeOfFeedback = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Positive", DbType="Float")]
		public System.Nullable<double> Positive
		{
			get
			{
				return this._Positive;
			}
			set
			{
				if ((this._Positive != value))
				{
					this._Positive = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Negative", DbType="Float")]
		public System.Nullable<double> Negative
		{
			get
			{
				return this._Negative;
			}
			set
			{
				if ((this._Negative != value))
				{
					this._Negative = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Mean", DbType="Int")]
		public System.Nullable<int> Mean
		{
			get
			{
				return this._Mean;
			}
			set
			{
				if ((this._Mean != value))
				{
					this._Mean = value;
				}
			}
		}
	}
	
	public partial class spSummaryPagesResult
	{
		
		private string _Agency;
		
		private System.Nullable<int> _VolumeOfFeedback;
		
		private System.Nullable<double> _Positive;
		
		public spSummaryPagesResult()
		{
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Agency", DbType="VarChar(100)")]
		public string Agency
		{
			get
			{
				return this._Agency;
			}
			set
			{
				if ((this._Agency != value))
				{
					this._Agency = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_VolumeOfFeedback", DbType="Int")]
		public System.Nullable<int> VolumeOfFeedback
		{
			get
			{
				return this._VolumeOfFeedback;
			}
			set
			{
				if ((this._VolumeOfFeedback != value))
				{
					this._VolumeOfFeedback = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Positive", DbType="Float")]
		public System.Nullable<double> Positive
		{
			get
			{
				return this._Positive;
			}
			set
			{
				if ((this._Positive != value))
				{
					this._Positive = value;
				}
			}
		}
	}
	
	public partial class spGetSearchPagesResult
	{
		
		private string _URL;
		
		private string _Agency;
		
		private System.Nullable<int> _VolumeOfFeedback;
		
		private System.Nullable<double> _Positive;
		
		private string _PositiveNoOfComments;
		
		private string _NegativeNoOfComments;
		
		public spGetSearchPagesResult()
		{
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_URL", DbType="NVarChar(1024) NOT NULL", CanBeNull=false)]
		public string URL
		{
			get
			{
				return this._URL;
			}
			set
			{
				if ((this._URL != value))
				{
					this._URL = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Agency", DbType="VarChar(100)")]
		public string Agency
		{
			get
			{
				return this._Agency;
			}
			set
			{
				if ((this._Agency != value))
				{
					this._Agency = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_VolumeOfFeedback", DbType="Int")]
		public System.Nullable<int> VolumeOfFeedback
		{
			get
			{
				return this._VolumeOfFeedback;
			}
			set
			{
				if ((this._VolumeOfFeedback != value))
				{
					this._VolumeOfFeedback = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Positive", DbType="Float")]
		public System.Nullable<double> Positive
		{
			get
			{
				return this._Positive;
			}
			set
			{
				if ((this._Positive != value))
				{
					this._Positive = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_PositiveNoOfComments", DbType="VarChar(100)")]
		public string PositiveNoOfComments
		{
			get
			{
				return this._PositiveNoOfComments;
			}
			set
			{
				if ((this._PositiveNoOfComments != value))
				{
					this._PositiveNoOfComments = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_NegativeNoOfComments", DbType="VarChar(100)")]
		public string NegativeNoOfComments
		{
			get
			{
				return this._NegativeNoOfComments;
			}
			set
			{
				if ((this._NegativeNoOfComments != value))
				{
					this._NegativeNoOfComments = value;
				}
			}
		}
	}
	
	public partial class spGetCommentsResult
	{
		
		private string _utcDate;
		
		private string _PostiveComments;
		
		private string _NegativeComments;
		
		public spGetCommentsResult()
		{
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_utcDate", DbType="VarChar(30)")]
		public string utcDate
		{
			get
			{
				return this._utcDate;
			}
			set
			{
				if ((this._utcDate != value))
				{
					this._utcDate = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_PostiveComments", DbType="NVarChar(255)")]
		public string PostiveComments
		{
			get
			{
				return this._PostiveComments;
			}
			set
			{
				if ((this._PostiveComments != value))
				{
					this._PostiveComments = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_NegativeComments", DbType="NVarChar(255)")]
		public string NegativeComments
		{
			get
			{
				return this._NegativeComments;
			}
			set
			{
				if ((this._NegativeComments != value))
				{
					this._NegativeComments = value;
				}
			}
		}
	}
	
	public partial class spGetAgencyListResult
	{
		
		private string _Agency;
		
		public spGetAgencyListResult()
		{
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Agency", DbType="VarChar(100)")]
		public string Agency
		{
			get
			{
				return this._Agency;
			}
			set
			{
				if ((this._Agency != value))
				{
					this._Agency = value;
				}
			}
		}
	}
	
	public partial class spGetTrendResultsResult
	{
		
		private string _Unit;
		
		private System.Nullable<int> _VolumeOfFeedback;
		
		private string _PositiveNoOfComments;
		
		private string _NegativeNoOfComments;
		
		public spGetTrendResultsResult()
		{
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Unit", DbType="VarChar(30)")]
		public string Unit
		{
			get
			{
				return this._Unit;
			}
			set
			{
				if ((this._Unit != value))
				{
					this._Unit = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_VolumeOfFeedback", DbType="Int")]
		public System.Nullable<int> VolumeOfFeedback
		{
			get
			{
				return this._VolumeOfFeedback;
			}
			set
			{
				if ((this._VolumeOfFeedback != value))
				{
					this._VolumeOfFeedback = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_PositiveNoOfComments", DbType="VarChar(100)")]
		public string PositiveNoOfComments
		{
			get
			{
				return this._PositiveNoOfComments;
			}
			set
			{
				if ((this._PositiveNoOfComments != value))
				{
					this._PositiveNoOfComments = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_NegativeNoOfComments", DbType="VarChar(100)")]
		public string NegativeNoOfComments
		{
			get
			{
				return this._NegativeNoOfComments;
			}
			set
			{
				if ((this._NegativeNoOfComments != value))
				{
					this._NegativeNoOfComments = value;
				}
			}
		}
	}
}
#pragma warning restore 1591