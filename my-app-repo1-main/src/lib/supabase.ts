import { createClient } from '@supabase/supabase-js'

// For Lovable Supabase integration, these should be automatically provided
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://your-project.supabase.co'
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'your-anon-key'

// Create Supabase client - will work with Lovable's native integration
export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Database types
export interface School {
  id: number
  name: string
  address: string
  city: string
  state: string
  contact: string
  image: string
  email_id: string
  created_at?: string
}